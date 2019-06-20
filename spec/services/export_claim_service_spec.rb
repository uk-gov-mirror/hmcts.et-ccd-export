require 'spec_helper'
RSpec.describe ExportClaimService do
  subject(:service) { described_class.new }

  shared_context 'with stubbed ccd' do
    before do
      stub_request(:any, Addressable::Template.new(export.external_system.config[:idam_service_token_exchange_url])).to_rack(EtFakeCcd::Idam::ServiceTokenServer)
      stub_request(:any, Addressable::Template.new(export.external_system.config[:idam_user_token_exchange_url])).to_rack(EtFakeCcd::Idam::UserTokenServer)
      stub_request(:any, Addressable::Template.new(export.external_system.config[:create_case_url])).to_rack(EtFakeCcd::Server)
      stub_request(:any, Addressable::Template.new(export.external_system.config[:initiate_case_url])).to_rack(EtFakeCcd::Server)
    end
  end
  describe '#call' do
    let(:export) { create(:export, :for_claim) }
    # include_context 'with stubbed ccd'

    it 'requests a token as it doesnt have one' do
      #service.call(export)
    end

    it 'only requests a token the first time'
    it 'performs a request to create a case with a valid token'
    it 'performs a request to create a case with valid primary claim data'
    it 'performs a request to create a case with valid primary claimant data'
    it 'performs a request to create a case with valid primary respondent data'
    it 'performs a request to create a case with valid primary representative data'
    it 'performs a request to create a case with valid pdf document'
    it 'returns a success when the service responds positively'
    it 'returns a failure when the service respondes negatively'

  end
end
