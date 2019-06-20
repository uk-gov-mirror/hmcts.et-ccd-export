module ClaimPresenter
  def self.present(claim, event_token:)
    ::ApplicationController.render(template: 'export_claim_service/top.json.jbuilder', locals: { claim: claim, event_token: event_token })
  end
end
