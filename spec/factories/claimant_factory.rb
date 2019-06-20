FactoryBot.define do
  factory :claimant, class: ::EtCcdExport::Test::Json::Node do
    trait(:default) do
      title { "Mr" }
      first_name { "First" }
      last_name { "Last" }
      address { build(:address) }
      address_telephone_number { "01234 567890" }
      mobile_number { "01234 098765" }
      email_address { "test@digital.justice.gov.uk" }
      contact_preference { "email" }
      gender { "Male" }
      date_of_birth { "1982-11-21" }
      fax_number { nil }
      special_needs { nil }
    end
  end
end
