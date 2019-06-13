FactoryBot.define do
  factory :system, class: ::EtCcdExport::Test::Json::Node do
    sequence(:id) { |idx| idx }
    sequence(:name) { |idx| "CCD Instance #{idx}" }
    reference { "ccd_instance_#{id}" }
    office_codes { [] }
    enabled { true }
    config do
      {
        url: 'http://someurl.com',
        idam_service_token_exchange_url: 'http://localhost:4502/testing-support/lease',
        idam_user_token_exchange_url: 'http://localhost:4501/testing-support/lease',
        create_case_url: 'http://localhost:4452/caseworkers/{uid}/jurisdictions/{jid}/case-types/{ctid}/cases',
        initiate_case_url: 'http://localhost:4452/caseworkers/{uid}/jurisdictions/{jid}/case-types/{ctid}/event-triggers/{etid}/token',
        user_id: 22,
        user_role: 'caseworker,caseworker-test,caseworker-employment-tribunal-manchester,caseworker-employment,caseworker-employment-tribunal-manchester-caseofficer,caseworker-publiclaw-localAuthority',
        secret: 'AAAAAAAAAAAAAAAC',
        jurisdiction_id: 'EMPLOYMENT',
        case_type_id: 'EmpTrib_MVP_1.0_Manc',
        initiate_claim_event_id: 'initiateCase'
      }
    end
  end
end
