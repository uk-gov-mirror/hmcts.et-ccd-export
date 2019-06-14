FactoryBot.define do
  factory :claim, class: ::EtCcdExport::Test::Json::Node do
    transient do
      number_of_claimants { 1 }
      number_of_respondents { 1 }
      primary_respondent_traits { [:full] }
      primary_respondent_attrs { {} }
      primary_claimant_attrs { {} }
      primary_claimant_traits { [:default] }
      secondary_claimant_traits { [:mr_first_last] }
      secondary_respondent_traits { [:full] }
      secondary_respondent_attrs { {} }
      primary_representative_traits { [:full] }
      primary_representative_attrs { {} }
      employment_details_traits { [:employed] }
      employment_details_attrs { {} }
    end

    trait :default do
      sequence :reference do |n|
        "#{office_code}#{20000000 + n}00"
      end

      sequence :submission_reference do |n|
        "J704-ZK5E#{n}"
      end
      claimant_count { number_of_claimants }
      submission_channel { "Web" }
      case_type { "Single" }
      jurisdiction { 2 }
      office_code { 22 }
      date_of_receipt { "2019-06-12T07:28:58.000Z" }
      administrator { nil }
      other_known_claimant_names { "" }
      discrimination_claims { [] }
      pay_claims { [] }
      desired_outcomes { [] }
      other_claim_details { "" }
      claim_details { "" }
      other_outcome { "" }
      send_claim_to_whistleblowing_entity { false }
      miscellaneous_information { "" }
      is_unfair_dismissal { false }
      pdf_template_reference { "et1-v1-en" }
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

    secondary_claimants { [] }
    secondary_respondents { [] }
    uploaded_files { [] }

    after(:build) do |claim, evaluator|
      claim.primary_claimant = build(:claimant, *evaluator.primary_claimant_traits, **evaluator.primary_claimant_attrs) if claim.primary_claimant.blank? && evaluator.number_of_claimants > 0
      claim.secondary_claimants.concat build_list(:claimant, evaluator.number_of_claimants - 1, *evaluator.secondary_claimant_traits) unless evaluator.number_of_claimants < 1
      claim.primary_respondent = build(:respondent, *evaluator.primary_respondent_traits, **evaluator.primary_respondent_attrs) if claim.primary_respondent.blank? && evaluator.number_of_respondents > 0
      claim.secondary_respondents.concat build_list(:respondent, evaluator.number_of_respondents - 1, *evaluator.secondary_respondent_traits, **evaluator.secondary_respondent_attrs) unless evaluator.number_of_respondents < 1
      claim.claimant_count = evaluator.number_of_claimants
      claim.primary_representative = build(:representative, *evaluator.primary_representative_traits, **evaluator.primary_representative_attrs) unless evaluator.primary_representative_traits.nil?
      claim.employment_details = build(:employment_details, *evaluator.employment_details_traits, **evaluator.employment_details_attrs)
    end

    trait :with_pdf_file do
      after(:build) do |claim, _evaluator|
        claim.uploaded_files << build(:uploaded_file, :example_pdf)
      end
    end

    trait :with_rtf_file do
      after(:build) do |claim, _evaluator|
        claim.uploaded_files << build(:uploaded_file, :example_claim_rtf)
      end
    end

    trait :with_claimants_csv_file do
      after(:build) do |claim, _evaluator|
        claim.uploaded_files << build(:uploaded_file, :example_claim_claimants_csv)
      end
    end

    trait :no_representative do
      primary_representative_traits { [] }
    end

    trait :default_multiple_claimants do
      default
      secondary_claimants do
        [
          build(:claimant, :tamara_swift),
          build(:claimant, :diana_flatley),
          build(:claimant, :mariana_mccullough),
          build(:claimant, :eden_upton),
          build(:claimant, :annie_schulist),
          build(:claimant, :thad_johns),
          build(:claimant, :coleman_kreiger),
          build(:claimant, :jenson_deckow),
          build(:claimant, :darien_bahringer),
          build(:claimant, :eulalia_hammes)
        ]
      end
      uploaded_files { [build(:uploaded_file, :example_data), build(:uploaded_file, :example_claim_claimants_csv)] }
    end
  end
end
