require 'rails_helper'
require 'ice_nine'  # For deep freezing
RSpec.describe ExportMultipleClaimsService do
  subject(:service) { described_class.new(supervisor: mock_supervisor) }

  let(:mock_supervisor) { class_spy('MultiplesSupervisorService') }

  describe '#call' do
    def primaryClaimantIndTypeMatcher(claimant, has_gender: true)
      a_hash_including 'claimant_title1' => claimant.title,
                       'claimant_first_names' => claimant.first_name,
                       'claimant_last_name' => claimant.last_name,
                       'claimant_date_of_birth' => claimant.date_of_birth,
                       'claimant_gender' => has_gender ? claimant.gender : nil
    end

    def primaryClaimantTypeMatcher(claimant)
      a_hash_including 'claimant_addressUK' => address_matcher(claimant.address),
                       'claimant_phone_number' => claimant.address_telephone_number,
                       'claimant_mobile_number' => claimant.mobile_number,
                       'claimant_email_address' => claimant.email_address,
                       'claimant_contact_preference' => claimant.contact_preference&.humanize
    end

    def address_matcher(address, has_country: true)
      a_hash_including 'AddressLine1' => address.building,
                       'AddressLine2' => address.street,
        'PostTown' => address.locality,
        'County' => address.county,
        'PostCode' => address.post_code,
        'Country' => has_country && ['United Kingdom'].include?(address.country) ? address.country : nil
    end

    def secondaryClaimantIndTypeMatcher(claimant)
      primaryClaimantIndTypeMatcher(claimant, has_gender: false)
    end

    def secondaryClaimantTypeMatcher(claimant)
      a_hash_including 'claimant_addressUK' => address_matcher(claimant.address, has_country: false),
        'claimant_phone_number' => nil,
        'claimant_mobile_number' => nil,
        'claimant_email_address' => nil,
        'claimant_contact_preference' => nil
    end

    def primaryClaimantOtherTypeMatcher(claimant, claim)
      hash_for_comparison = {
        'claimant_disabled' => claimant.special_needs.present? ? 'Yes' : 'No'

      }
      if claim.employment_details.present?
        hash_for_comparison.merge! \
          'claimant_employed_currently' => currently_employed?(claim) ? 'Yes' : 'No',
          'claimant_occupation' => claim.employment_details.job_title,
          'claimant_employed_from' => claim.employment_details.start_date,
          'claimant_employed_to' => claim.employment_details.end_date,
          'claimant_employed_notice_period' => claim.employment_details.notice_period_end_date
      end
      hash_for_comparison['claimant_disabled_details'] = claimant.special_needs if claimant.special_needs.present?
      a_hash_including hash_for_comparison
    end

    def primaryClaimantWorkAddressMatcher(claimant, claim)
      address = claim.primary_respondent.work_address.present? ? claim.primary_respondent.work_address : claim.primary_respondent.address
      a_hash_including('claimant_work_address' => address_matcher(address, has_country: false))
    end

    def currently_employed?(claim)
      return nil unless claim.employment_details.present?

      claim.employment_details.start_date.present? && (claim.employment_details.end_date.nil? || Date.parse(claim.employment_details.end_date) > Date.today)
    end

    RSpec::Matchers.define :json_matching do |sub_matcher|
      match do |actual|
        json = JSON.parse(actual)
        expect(json).to sub_matcher
      end
    end

    context 'with secondary claimants from csv file' do
      let(:example_export) { build(:export, :for_claim, claim_traits: [:default_multiple_claimants]) }

      it 'requests supervision for each claimant including primary' do
        # Act - Call the service
        service.call(example_export.as_json)

        # Assert - ensure the spy was called for each one
        expect(mock_supervisor).to have_received(:supervise).with(group_name: example_export.resource.reference, count: example_export.resource.secondary_claimants.length + 1)
      end

      # The supervisor will receive an add_job call for each job it needs to supervise.
      # This add_job is called with the json from the original ET JSON but modified
      # so that the primary claimant is the secondary claimant of interest
      # and the secondary claimants are empty.  This shrinks the json size down as the
      # secondary claimants are not relevant - as each secondary claimant gets its own job
      it 'schedules all claimants with the correct fee group references' do
        # Act - Call the service
        service.call(example_export.as_json)

        # Assert - Calculate the expected json and check for it
        claimant_count = example_export.resource.secondary_claimants.length + 1
        json_matcher = json_matching(a_hash_including 'feeGroupReference' => example_export.resource.reference)
        expect(mock_supervisor).to have_received(:add_job).with(json_matcher, group_name: example_export.resource.reference).exactly(claimant_count).times
      end

      it 'schedules the primary claimant with the correct claimantIndType via the supervisor' do
        # Act - Call the service
        service.call(example_export.as_json)

        # Assert - Calculate the expected json and check for it
        json_matcher = json_matching(a_hash_including 'claimantIndType' => primaryClaimantIndTypeMatcher(example_export.resource.primary_claimant))
        expect(mock_supervisor).to have_received(:add_job).with(json_matcher, group_name: example_export.resource.reference).once
      end

      it 'schedules the primary claimant with the correct claimantType via the supervisor' do
        # Act - Call the service
        service.call(example_export.as_json)

        # Assert - Calculate the expected json and check for it
        json_matcher = json_matching(a_hash_including 'claimantType' => primaryClaimantTypeMatcher(example_export.resource.primary_claimant))
        expect(mock_supervisor).to have_received(:add_job).with(json_matcher, group_name: example_export.resource.reference).once
      end

      it 'schedules the primary claimant with the correct claimantOtherType via the supervisor' do
        # Act - Call the service
        service.call(example_export.as_json)

        # Assert - Calculate the expected json and check for it
        json_matcher = json_matching(a_hash_including 'claimantOtherType' => primaryClaimantOtherTypeMatcher(example_export.resource.primary_claimant, example_export.resource))
        expect(mock_supervisor).to have_received(:add_job).with(json_matcher, group_name: example_export.resource.reference).once
      end

      it 'schedules the primary claimant with the correct claimantWorkAddress via the supervisor' do
        # Act - Call the service
        service.call(example_export.as_json)

        # Assert - Calculate the expected json and check for it
        json_matcher = json_matching(a_hash_including 'claimantWorkAddress' => primaryClaimantWorkAddressMatcher(example_export.resource.primary_claimant, example_export.resource))
        expect(mock_supervisor).to have_received(:add_job).with(json_matcher, group_name: example_export.resource.reference).once
      end






      it 'schedules the secondary claimants with  the correct claimantIndType' do
        # Act - Call the service
        service.call(example_export.as_json)

        example_export.resource.secondary_claimants.each do |claimant|
          json_matcher = json_matching(a_hash_including 'claimantIndType' => secondaryClaimantIndTypeMatcher(claimant))
          expect(mock_supervisor).to have_received(:add_job).with(json_matcher, group_name: example_export.resource.reference).once
        end
      end

      it 'schedules the secondary claimants with  the correct claimantType' do
        # Act - Call the service
        service.call(example_export.as_json)

        example_export.resource.secondary_claimants.each do |claimant|
          json_matcher = json_matching(a_hash_including 'claimantType' => secondaryClaimantTypeMatcher(claimant))
          expect(mock_supervisor).to have_received(:add_job).with(json_matcher, group_name: example_export.resource.reference).once
        end
      end

      it 'schedules the secondary claimants with the correct claimantOtherType' do
        # Act - Call the service
        service.call(example_export.as_json)

        # Assert - all 'n' times the job has been added, it should have had empty claimantOtherType
        json_matcher = json_matching(a_hash_including 'claimantOtherType' => {})
        expect(mock_supervisor).to have_received(:add_job).
          with(json_matcher, group_name: example_export.resource.reference).
          exactly(example_export.resource.secondary_claimants.length).times
      end

      it 'schedules the secondary claimants with the correct claimantWorkAddress' do
        # Act - Call the service
        service.call(example_export.as_json)

        # Assert - all 'n' times the job has been added, it should have and empty claimantWorkAddress for all secondaries
        json_matcher = json_matching(a_hash_including 'claimantWorkAddress' => {})
        expect(mock_supervisor).to have_received(:add_job).
          with(json_matcher, group_name: example_export.resource.reference).
          exactly(example_export.resource.secondary_claimants.length).times
      end

      it 'must not modify original data' do
        # Arrange - Deep freeze the original
        data = example_export.as_json
        IceNine.deep_freeze(data)

        # Act - Call the service
        action = -> { service.call(data) }

        # Assert - Make sure it does not raise frozen error
        expect(action).not_to raise_exception(FrozenError)
      end
    end
  end
end
