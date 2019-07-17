class MultipleClaimsHeaderPresenter
  def self.present(primary_reference:, case_references:, event_token:)
    ::ApplicationController.render(template: 'export_multiple_claims_service/header.json.jbuilder', locals: { primary_reference: primary_reference, case_references: case_references, event_token: event_token })
  end
end
