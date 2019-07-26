FactoryBot.define do
  factory :uploaded_file, class: ::EtCcdExport::Test::Json::Node do
    filename { nil }
    url { nil }
    
    trait :example_pdf do
      filename { "et1_chloe_goodwin.pdf" }
      url { "http://dummy.com/et1_chloe_goodwin.pdf" }
    end

    trait :example_claim_claimants_csv do
      filename { 'et1a_first_last.csv' }
      url { "http://dummy.com/et1_chloe_goodwin.csv" }
    end
  end
end
