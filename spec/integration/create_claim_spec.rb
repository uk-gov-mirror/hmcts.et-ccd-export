require 'rails_helper'
RSpec.describe "create claim" do
  subject(:worker) { ::EtExporter::ExportClaimWorker }
  let(:test_ccd_client) { EtCcdClient::UiClient.new.tap {|c| c.login(username: 'm@m.com', password: 'Pa55word11')} }
  include_context 'with stubbed ccd'

  it 'creates a claim in ccd' do
    # Arrange - Produce the input JSON
    export = build(:export, :for_claim)

    # Act - Call the worker in the same way the application would (minus using redis)
    worker.perform_async(export.as_json.to_json)
    worker.drain

    # Assert - Check with CCD (or fake CCD) to see what we sent
    ccd_case = test_ccd_client.caseworker_search_latest_by_reference(export.resource.reference, case_type_id: 'EmpTrib_MVP_1.0_Manc')
    expect(ccd_case['case_fields']).to include 'feeGroupReference' => export.resource.reference
  end

  it 'creates a claim in ccd that matches the schema' do
    # Arrange - Produce the input JSON
    export = build(:export, :for_claim)

    # Act - Call the worker in the same way the application would (minus using redis)
    worker.perform_async(export.as_json.to_json)
    worker.drain

    # Assert - Check with CCD (or fake CCD) to see what we sent
    ccd_case = test_ccd_client.caseworker_search_latest_by_reference(export.resource.reference, case_type_id: 'EmpTrib_MVP_1.0_Manc')
    expect(ccd_case['case_fields']).to match_json_schema('case_create')
  end

  it 'populates the claimant data correctly with an address specifying UK country' do
    # Arrange - Produce the input JSON
    claimant = build(:claimant, :default, address: build(:address, :with_uk_country))
    export = build(:export, :for_claim, resource: build(:claim, :default, primary_claimant: claimant))

    # Act - Call the worker in the same way the application would (minus using redis)
    worker.perform_async(export.as_json.to_json)
    worker.drain

    # Assert - Check with CCD (or fake CCD) to see what we sent
    ccd_case = test_ccd_client.caseworker_search_latest_by_reference(export.resource.reference, case_type_id: 'EmpTrib_MVP_1.0_Manc')
    ccd_claimant = ccd_case.dig('case_fields', 'claimantType')
    expect(ccd_claimant).to include "claimant_phone_number" => claimant.address_telephone_number,
                                    "claimant_mobile_number" => claimant.mobile_number,
                                    "claimant_email_address" => claimant.email_address,
                                    "claimant_contact_preference" => claimant.contact_preference.titleize,
                                    "claimant_addressUK" => {
                                        "AddressLine1" => claimant.address.building,
                                        "AddressLine2" => claimant.address.street,
                                        "PostTown" => claimant.address.locality,
                                        "County" => claimant.address.county,
                                        "PostCode" => claimant.address.post_code,
                                        "Country" => claimant.address.country
                                    }
  end

  it 'populates the claimant data correctly with an address specifying Non UK country (country should be nil)' do
    # Arrange - Produce the input JSON
    claimant = build(:claimant, :default, address: build(:address, :with_other_country))
    export = build(:export, :for_claim, resource: build(:claim, :default, primary_claimant: claimant))

    # Act - Call the worker in the same way the application would (minus using redis)
    worker.perform_async(export.as_json.to_json)
    worker.drain

    # Assert - Check with CCD (or fake CCD) to see what we sent
    ccd_case = test_ccd_client.caseworker_search_latest_by_reference(export.resource.reference, case_type_id: 'EmpTrib_MVP_1.0_Manc')
    ccd_claimant = ccd_case.dig('case_fields', 'claimantType')
    expect(ccd_claimant).to include "claimant_phone_number" => claimant.address_telephone_number,
                                    "claimant_mobile_number" => claimant.mobile_number,
                                    "claimant_email_address" => claimant.email_address,
                                    "claimant_contact_preference" => claimant.contact_preference.titleize,
                                    "claimant_addressUK" => {
                                        "AddressLine1" => claimant.address.building,
                                        "AddressLine2" => claimant.address.street,
                                        "PostTown" => claimant.address.locality,
                                        "County" => claimant.address.county,
                                        "PostCode" => claimant.address.post_code,
                                        "Country" => nil
                                    }
  end

  it 'populates the claimant data correctly with an address without any country in the input data (backward compatibility)' do
    # Arrange - Produce the input JSON
    claimant = build(:claimant, :default, address: build(:address))
    export = build(:export, :for_claim, resource: build(:claim, :default, primary_claimant: claimant))

    # Act - Call the worker in the same way the application would (minus using redis)
    worker.perform_async(export.as_json.to_json)
    worker.drain

    # Assert - Check with CCD (or fake CCD) to see what we sent
    ccd_case = test_ccd_client.caseworker_search_latest_by_reference(export.resource.reference, case_type_id: 'EmpTrib_MVP_1.0_Manc')
    ccd_claimant = ccd_case.dig('case_fields', 'claimantType')
    expect(ccd_claimant).to include "claimant_phone_number" => claimant.address_telephone_number,
                                    "claimant_mobile_number" => claimant.mobile_number,
                                    "claimant_email_address" => claimant.email_address,
                                    "claimant_contact_preference" => claimant.contact_preference.titleize,
                                    "claimant_addressUK" => {
                                        "AddressLine1" => claimant.address.building,
                                        "AddressLine2" => claimant.address.street,
                                        "PostTown" => claimant.address.locality,
                                        "County" => claimant.address.county,
                                        "PostCode" => claimant.address.post_code,
                                        "Country" => nil
                                    }
  end
end
