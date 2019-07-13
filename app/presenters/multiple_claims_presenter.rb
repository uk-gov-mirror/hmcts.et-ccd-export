module MultipleClaimsPresenter
  def self.present(claim, claimant:, lead_claimant: false)
    ::ApplicationController.render(template: 'export_multiple_claims_service/data.json.jbuilder', locals: { claim: claim, claimant: claimant, lead_claimant: lead_claimant })
  end
end
