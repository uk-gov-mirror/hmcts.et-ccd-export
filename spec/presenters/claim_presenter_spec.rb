require 'spec_helper'
require 'json'
require_relative '../../app/presenters/et_ccd_export/claim_presenter'
RSpec.describe EtCcdExport::ClaimPresenter do
  subject(:presenter) { described_class }
  def ccd_field(result, path)
    result_json = JSON.parse(result)
    result_json.dig('data', *path.split('.'))
  end

  describe '#present' do
    RSpec::Matchers.define :present_ccd_field do |ccd_field_path|
      undefined = Object.new
      expected_result = undefined
      @ccd_field_path = ccd_field_path
      match do |presenter|
        result = presenter.present(build(*@from_args).as_json, event_token: 'event token')
        result_json = JSON.parse(result)
        ccd_field_path_nodes = ccd_field_path.split('.')
        parent = result_json.dig('data', *ccd_field_path_nodes[0..-2])
        @key_present = parent.is_a?(Hash) && parent.key?(*ccd_field_path_nodes.last)
        @result = result_json.dig('data', *ccd_field_path_nodes)
        if expected_result == undefined
          @key_present
        else
          @key_present && @result == expected_result
        end
      end

      failure_message do |actual|
        if @key_present
          "expected the presenter to present \"#{expected_result}\" in \"data.#{ccd_field_path}\" but \"#{@result}\" was presented"
        else
          "expected the presenter to present \"data.#{ccd_field_path}\" but that key was not present in the data"
        end
      end

      failure_message_when_negated do |actual|
        if expected_result != undefined
          "expected the presenter not to present \"#{expected_result}\" in \"data.#{ccd_field_path}\" but it did"
        else expected_result == undefined
          "expected the presenter not to present \"data.#{ccd_field_path}\" but it did"
        end
      end

      chain :using do |*args|
        @from_args = args
      end
      chain :with_result do |new_expected_result|
        expected_result = new_expected_result
      end
    end
    context 'claimantIndType.claimant_title1' do
      it { is_expected.to present_ccd_field('claimantIndType.claimant_title1').using(:claim, primary_claimant_attrs: { title: 'Mrs' }).with_result('Mrs') }
      it { is_expected.to present_ccd_field('claimantIndType.claimant_title1').using(:claim, primary_claimant_attrs: { title: 'Mr' }).with_result('Mr') }
      it { is_expected.to present_ccd_field('claimantIndType.claimant_title1').using(:claim, primary_claimant_attrs: { title: nil }).with_result(nil) }
    end

    context 'claimantIndType.claimant_first_names' do
      it { is_expected.to present_ccd_field('claimantIndType.claimant_first_names').using(:claim, primary_claimant_attrs: { first_name: 'Example1 Name' }).with_result('Example1 Name') }
      it { is_expected.to present_ccd_field('claimantIndType.claimant_first_names').using(:claim, primary_claimant_attrs: { first_name: 'Example2 Name' }).with_result('Example2 Name') }
    end

    context 'claimantIndType.claimant_last_name' do
      it { is_expected.to present_ccd_field('claimantIndType.claimant_last_name').using(:claim, primary_claimant_attrs: { last_name: 'Example1' }).with_result('Example1') }
      it { is_expected.to present_ccd_field('claimantIndType.claimant_last_name').using(:claim, primary_claimant_attrs: { last_name: 'Example2' }).with_result('Example2') }
    end

    context 'claimantIndType.claimant_date_of_birth' do
      it { is_expected.to present_ccd_field('claimantIndType.claimant_date_of_birth').using(:claim, primary_claimant_attrs: { date_of_birth: '1970-07-06' }).with_result('1970-07-06') }
      it { is_expected.to present_ccd_field('claimantIndType.claimant_date_of_birth').using(:claim, primary_claimant_attrs: { date_of_birth: '1984-12-31' }).with_result('1984-12-31') }
    end

    context 'claimantIndType.claimant_gender' do
      it { is_expected.to present_ccd_field('claimantIndType.claimant_gender').using(:claim, primary_claimant_attrs: { gender: 'Male' }).with_result('Male') }
      it { is_expected.to present_ccd_field('claimantIndType.claimant_gender').using(:claim, primary_claimant_attrs: { gender: 'Female' }).with_result('Female') }
      it { is_expected.to present_ccd_field('claimantIndType.claimant_gender').using(:claim, primary_claimant_attrs: { gender: 'N/K' }).with_result('N/K') }
      it { is_expected.to present_ccd_field('claimantIndType.claimant_gender').using(:claim, primary_claimant_attrs: { gender: 'Something Wrong' }).with_result(nil) }
      it { is_expected.to present_ccd_field('claimantIndType.claimant_gender').using(:claim, primary_claimant_attrs: { gender: nil }).with_result(nil) }
    end

    context 'claimantOtherType.claimant_disabled' do
      it { is_expected.to present_ccd_field('claimantOtherType.claimant_disabled').using(:claim, primary_claimant_attrs: { special_needs: 'Some special needs' }).with_result('Yes') }
      it { is_expected.to present_ccd_field('claimantOtherType.claimant_disabled').using(:claim, primary_claimant_attrs: { special_needs: '' }).with_result('No') }
      it { is_expected.to present_ccd_field('claimantOtherType.claimant_disabled').using(:claim, primary_claimant_attrs: { special_needs: nil }).with_result('No') }
    end

    context 'claimantOtherType.claimant_disabled_details' do
      it { is_expected.to present_ccd_field('claimantOtherType.claimant_disabled_details').using(:claim, primary_claimant_attrs: { special_needs: 'Example1 special needs' }).with_result('Example1 special needs') }
      it { is_expected.to present_ccd_field('claimantOtherType.claimant_disabled_details').using(:claim, primary_claimant_attrs: { special_needs: 'Example2 special needs' }).with_result('Example2 special needs') }
      it { is_expected.to_not present_ccd_field('claimantOtherType.claimant_disabled_details').using(:claim, primary_claimant_attrs: { special_needs: nil }) }
      it { is_expected.to_not present_ccd_field('claimantOtherType.claimant_disabled_details').using(:claim, primary_claimant_attrs: { special_needs: '' }) }
    end

    context 'claimantType.claimant_addressUK.AddressLine1' do
      it { is_expected.to present_ccd_field('claimantType.claimant_addressUK.AddressLine1').using(:claim, primary_claimant_attrs: { address: { 'building' => 'Example1 Building' } }).with_result('Example1 Building') }
      it { is_expected.to present_ccd_field('claimantType.claimant_addressUK.AddressLine1').using(:claim, primary_claimant_attrs: { address: { 'building' => 'Example2 Building' } }).with_result('Example2 Building') }
      it { is_expected.to present_ccd_field('claimantType.claimant_addressUK.AddressLine1').using(:claim, primary_claimant_attrs: { address: { 'building' => nil } }).with_result(nil) }
    end

    context 'claimantType.claimant_addressUK.AddressLine2' do

      it { is_expected.to present_ccd_field('claimantType.claimant_addressUK.AddressLine2').using(:claim, primary_claimant_attrs: { address: { 'street' => 'Example1 Street' } }).with_result('Example1 Street') }
      it { is_expected.to present_ccd_field('claimantType.claimant_addressUK.AddressLine2').using(:claim, primary_claimant_attrs: { address: { 'street' => 'Example2 Street' } }).with_result('Example2 Street') }
      it { is_expected.to present_ccd_field('claimantType.claimant_addressUK.AddressLine2').using(:claim, primary_claimant_attrs: { address: { 'street' => nil } }).with_result(nil) }
    end

    context 'claimantType.claimant_addressUK.AddressLine3' do
      it { is_expected.to_not present_ccd_field('claimantType.claimant_addressUK.AddressLine3').using(:claim) }
    end

    context 'claimantType.claimant_addressUK.PostTown' do
      it { is_expected.to present_ccd_field('claimantType.claimant_addressUK.PostTown').using(:claim, primary_claimant_attrs: { address: { 'locality' => 'Example1 Town' } }).with_result('Example1 Town') }
      it { is_expected.to present_ccd_field('claimantType.claimant_addressUK.PostTown').using(:claim, primary_claimant_attrs: { address: { 'locality' => 'Example2 Town' } }).with_result('Example2 Town') }
      it { is_expected.to present_ccd_field('claimantType.claimant_addressUK.PostTown').using(:claim, primary_claimant_attrs: { address: { 'locality' => nil } }).with_result(nil) }
    end

    context 'claimantType.claimant_addressUK.County' do
      it { is_expected.to present_ccd_field('claimantType.claimant_addressUK.County').using(:claim, primary_claimant_attrs: { address: { 'county' => 'Example1 County' } }).with_result('Example1 County') }
      it { is_expected.to present_ccd_field('claimantType.claimant_addressUK.County').using(:claim, primary_claimant_attrs: { address: { 'county' => 'Example2 County' } }).with_result('Example2 County') }
      it { is_expected.to present_ccd_field('claimantType.claimant_addressUK.County').using(:claim, primary_claimant_attrs: { address: { 'county' => nil } }).with_result(nil) }
    end

    context 'claimantType.claimant_addressUK.PostCode' do
      it { is_expected.to present_ccd_field('claimantType.claimant_addressUK.PostCode').using(:claim, primary_claimant_attrs: { address: { 'post_code' => 'Example1 Postcode' } }).with_result('Example1 Postcode') }
      it { is_expected.to present_ccd_field('claimantType.claimant_addressUK.PostCode').using(:claim, primary_claimant_attrs: { address: { 'post_code' => 'Example2 Postcode' } }).with_result('Example2 Postcode') }
      it { is_expected.to present_ccd_field('claimantType.claimant_addressUK.PostCode').using(:claim, primary_claimant_attrs: { address: { 'post_code' => nil } }).with_result(nil) }
    end

    context 'claimantType.claimant_addressUK.Country' do
      it { is_expected.to present_ccd_field('claimantType.claimant_addressUK.Country').using(:claim, primary_claimant_attrs: { address: { 'country' => 'United Kingdom' } }).with_result('United Kingdom') }
      it { is_expected.to present_ccd_field('claimantType.claimant_addressUK.Country').using(:claim, primary_claimant_attrs: { address: { 'country' => 'Something Else' } }).with_result(nil) }
      it { is_expected.to present_ccd_field('claimantType.claimant_addressUK.Country').using(:claim, primary_claimant_attrs: { address: { 'country' => nil } }).with_result(nil) }
    end

    context 'claimantType.claimant_phone_number' do
      it { is_expected.to present_ccd_field('claimantType.claimant_phone_number').using(:claim, primary_claimant_attrs: { address_telephone_number: 'Example number 1' }).with_result('Example number 1') }
      it { is_expected.to present_ccd_field('claimantType.claimant_phone_number').using(:claim, primary_claimant_attrs: { address_telephone_number: 'Example number 2' }).with_result('Example number 2') }
      it { is_expected.to present_ccd_field('claimantType.claimant_phone_number').using(:claim, primary_claimant_attrs: { address_telephone_number: nil }).with_result(nil) }
    end

    context 'claimantType.claimant_mobile_number' do
      it { is_expected.to present_ccd_field('claimantType.claimant_mobile_number').using(:claim, primary_claimant_attrs: { mobile_number: 'Example number 1' }).with_result('Example number 1') }
      it { is_expected.to present_ccd_field('claimantType.claimant_mobile_number').using(:claim, primary_claimant_attrs: { mobile_number: 'Example number 2' }).with_result('Example number 2') }
      it { is_expected.to present_ccd_field('claimantType.claimant_mobile_number').using(:claim, primary_claimant_attrs: { mobile_number: nil }).with_result(nil) }
    end

    context 'claimantType.claimant_email_address' do
      it { is_expected.to present_ccd_field('claimantType.claimant_email_address').using(:claim, primary_claimant_attrs: { email_address: 'test1@example.com' }).with_result('test1@example.com') }
      it { is_expected.to present_ccd_field('claimantType.claimant_email_address').using(:claim, primary_claimant_attrs: { email_address: 'test1@example.com' }).with_result('test1@example.com') }
      it { is_expected.to present_ccd_field('claimantType.claimant_email_address').using(:claim, primary_claimant_attrs: { email_address: nil }).with_result(nil) }
    end

    context 'claimantType.claimant_contact_preference' do
      it { is_expected.to present_ccd_field('claimantType.claimant_contact_preference').using(:claim, primary_claimant_attrs: { contact_preference: 'Email' }).with_result('Email') }
      it { is_expected.to present_ccd_field('claimantType.claimant_contact_preference').using(:claim, primary_claimant_attrs: { contact_preference: 'Post' }).with_result('Post') }
      it { is_expected.to present_ccd_field('claimantType.claimant_contact_preference').using(:claim, primary_claimant_attrs: { contact_preference: nil }).with_result(nil) }
    end















  end
end
