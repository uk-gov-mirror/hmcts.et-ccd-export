FactoryBot.define do
  factory :address, class: ::EtCcdExport::Test::Json::Node do
    building { '1' }
    street { 'street' }
    locality { 'locality' }
    county { 'county' }
    post_code { 'post code' }
  end
end
