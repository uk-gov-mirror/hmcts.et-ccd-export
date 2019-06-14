require 'et_ccd_export/view_renderer'
module EtCcdExport
  module ClaimPresenter
    def self.present(claim, event_token:)
      ViewRenderer.render(template: 'et_ccd_export/export_claim_service/top.json.jbuilder', locals: { claim: claim, event_token: event_token })
    end
  end
end
