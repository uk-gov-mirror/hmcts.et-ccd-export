require 'et_ccd_client'
require_relative '../../presenters/et_ccd_export/claim_presenter'
module EtCcdExport
  class ExportClaimService
    def initialize(client: EtCcdClient::Client.new)
      self.client = client
    end

    def call(export)
      client.login
      do_export(export)
    end

    private

    attr_accessor :client

    def do_export(export)
      case_type_id = export.external_system.config[:case_type_id]
      resp = client.caseworker_start_case_creation(case_type_id: case_type_id)
      event_token = resp['token']
      data = ClaimPresenter.present(export['resource'], event_token: event_token)
      client.caseworker_case_create(data, case_type_id: case_type_id)
    end
  end
end
