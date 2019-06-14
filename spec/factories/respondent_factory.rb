FactoryBot.define do
  factory :respondent, class: ::EtCcdExport::Test::Json::Node do
    trait :full do
      name { "dodgy_co" }
      address { build(:address) }
      work_address_telephone_number { "" }
      address_telephone_number { "" }
      acas_number { nil }
      work_address { build(:address) }
      alt_phone_number { "" }
      contact { "John Smith" }
      dx_number { "" }
      contact_preference { "email" }
      email_address { "john@dodgyco.com" }
      fax_number { "" }
      organisation_employ_gb { 10 }
      organisation_more_than_one_site { false }
      employment_at_site_number { 5 }
      disability { true }
      disability_information { "Lorem ipsum disability" }
      acas_certificate_number { "AC123456/78/90" }
      acas_exemption_code { nil }
    end
  end
end
