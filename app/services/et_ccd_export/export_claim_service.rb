require "addressable/template"
require 'rest_client'
require 'active_support/json'
require 'active_support/core_ext/module'
require_relative '../../presenters/et_ccd_export/claim_presenter'
module EtCcdExport
  class ExportClaimService
    def initialize
      self.service_token = nil
      self.user_token = nil
    end

    def call(export)
      self.service_token = exchange_service_token_for(export) unless service_token.present?
      self.user_token = exchange_user_token_for(export) unless user_token.present?
      do_export(export)
    end

    private

    attr_accessor :service_token, :user_token

    def do_export(export)
      config = export.external_system.config
      tpl = Addressable::Template.new(config[:create_case_url])
      url = tpl.expand(uid: config[:user_id], jid: config[:jurisdiction_id], ctid: config[:case_type_id]).to_s
      post_claim_to(url, claim: export.resource, event_token: event_token(export))
    end

    def exchange_service_token_for(export)
      url = export.external_system.config[:idam_service_token_exchange_url]
      resp = RestClient.post(url, {microservice: "ccd_gw"}.to_json, content_type: 'application/json')
      resp.body
    end

    def exchange_user_token_for(export) config = export.external_system.config
      url = config[:idam_user_token_exchange_url]
      resp = RestClient.post(url, {id: config[:user_id], role: config[:user_role]})
      resp.body
    end

    def event_token(export)
      config = export.external_system.config
      tpl = Addressable::Template.new(config[:initiate_case_url])
      url = tpl.expand(uid: config[:user_id], jid: config[:jurisdiction_id], ctid: config[:case_type_id], etid: config[:initiate_claim_event_id]).to_s
      resp = RestClient.get(url, content_type: 'application/json', 'ServiceAuthorization' => "Bearer #{service_token}", :authorization => "Bearer #{user_token}")
      JSON.parse(resp.body)['token']
    end

    def post_claim_to(url, claim:, event_token:)
      data = ClaimPresenter.present(claim, event_token: event_token)
      resp = RestClient.post(url, data, content_type: 'application/json', 'ServiceAuthorization' => "Bearer #{service_token}", :authorization => "Bearer #{user_token}")
      resp
    end
  end

end
