require 'rails_helper'
RSpec.describe "create claim" do
  subject(:worker) { ::EtExporter::ExportClaimWorker }
  let(:test_ccd_client) { EtCcdClient::Client.new }
  before { test_ccd_client.login }
  
  it 'creates a claim in ccd' do
    # Arrange - Produce the input JSON
    export = build(:export, :for_claim)
    
    # Act - Call the worker in the same way the application would (minus using redis)
    worker.perform_async(export.as_json.to_json)
    worker.drain
    
    # Assert - Check with CCD (or fake CCD) to see what we sent
    ccd_case = test_ccd_client.caseworker_search_latest_by_reference(export.resource.reference, case_type_id: 'EmpTrib_MVP_1.0_Manc')
    expect(ccd_case['state']).to eql '1_Submitted'
    expect(ccd_case['case_data']).to include 'feeGroupReference' => export.resource.reference
  end
end
