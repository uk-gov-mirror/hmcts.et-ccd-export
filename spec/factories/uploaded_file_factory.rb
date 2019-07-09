FactoryBot.define do
  factory :uploaded_file, class: ::EtCcdExport::Test::Json::Node do
    filename { nil }
    url { nil }
    
    trait :example_pdf do
      filename { "et1_chloe_goodwin.pdf" }
      url { "http://dummy.com/et1_chloe_goodwin.pdf" }
    end
  end
end
