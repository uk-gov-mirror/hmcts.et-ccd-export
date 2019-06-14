=begin
    "reference": "221000",
    "submission_reference": "J704-ZK5E",
    "claimant_count": 1,
    "submission_channel": "Web",
    "case_type": "Single",
    "jurisdiction": 2,
    "office_code": 22,
    "date_of_receipt": "2019-06-12T07:28:58.000Z",
    "administrator": null,
    "other_known_claimant_names": "",
    "discrimination_claims": [],
    "pay_claims": [],
    "desired_outcomes": [],
    "other_claim_details": "",
    "claim_details": "",
    "other_outcome": "",
    "send_claim_to_whistleblowing_entity": false,
    "miscellaneous_information": "",
    "employment_details": {
      "net_pay": 2000,
      "end_date": null,
      "gross_pay": 3000,
      "job_title": "agriculturist",
      "start_date": "2009-11-18",
      "found_new_job": null,
      "benefit_details": "Company car, private health care",
      "new_job_gross_pay": null,
      "new_job_start_date": null,
      "net_pay_period_type": "monthly",
      "gross_pay_period_type": "monthly",
      "notice_pay_period_type": null,
      "notice_period_end_date": null,
      "notice_pay_period_count": null,
      "enrolled_in_pension_scheme": true,
      "average_hours_worked_per_week": 38.0,
      "worked_notice_period_or_paid_in_lieu": null
    },
    "is_unfair_dismissal": false,
    "pdf_template_reference": "et1-v1-en",
    "secondary_claimants": [],
    "secondary_respondents": [],
    "primary_claimant": {
      "title": "Mr",
      "first_name": "First",
      "last_name": "Last",
      "address": {
        "building": "1",
        "street": "street",
        "locality": "locality",
        "county": "county",
        "post_code": "DE21 6ND"
      },
      "address_telephone_number": "01234 567890",
      "mobile_number": "01234 098765",
      "email_address": "test@digital.justice.gov.uk",
      "contact_preference": "Email",
      "gender": "Male",
      "date_of_birth": "1982-11-21",
      "fax_number": null,
      "special_needs": null
    },
    "primary_respondent": {
      "name": "dodgy_co",
      "address": {
        "building": "1",
        "street": "street",
        "locality": "locality",
        "county": "county",
        "post_code": "DE21 6ND"
      },
      "work_address_telephone_number": "",
      "address_telephone_number": "",
      "acas_number": null,
      "work_address": {
        "building": "1",
        "street": "street",
        "locality": "locality",
        "county": "county",
        "post_code": "DE21 6ND"
      },
      "alt_phone_number": "",
      "contact": "John Smith",
      "dx_number": "",
      "contact_preference": "email",
      "email_address": "john@dodgyco.com",
      "fax_number": "",
      "organisation_employ_gb": 10,
      "organisation_more_than_one_site": false,
      "employment_at_site_number": 5,
      "disability": true,
      "disability_information": "Lorem ipsum disability",
      "acas_certificate_number": "AC123456/78/90",
      "acas_exemption_code": null
    },
    "primary_representative": {
      "name": "Rep Name",
      "organisation_name": "Org name",
      "address": {
        "building": "1",
        "street": "street",
        "locality": "locality",
        "county": "county",
        "post_code": "DE21 6ND"
      },
      "address_telephone_number": "01234 5657899",
      "mobile_number": "07771 666555",
      "email_address": "test@email.com",
      "representative_type": "Solicitor",
      "dx_number": null,
      "reference": "rep ref",
      "contact_preference": "Email",
      "fax_number": "01234 555666"
    },
    "uploaded_files": [
      {
        "filename": "et1_first_last.pdf",
        "checksum": "ee2714b8b731a8c1e95dffaa33f89728",
        "url": "http://localhost:10000/devstoreaccount1/et-api-test-container/2Qnar7HebG8wtU7HrUqxjLPP?sp=r&sv=2016-05-31&se=2019-06-12T07%3A46%3A47Z&rscd=inline%3B+filename%3D%22et1_first_last.pdf%22%3B+filename*%3DUTF-8%27%27et1_first_last.pdf&rsct=application%2Fpdf&sr=b&sig=qcUQ4gonbWKjaUXsNQmRdSnR8wAsN%2FvpVwLgM%2FJFaIU%3D"
      },
      {
        "id": 22,
        "filename": "et1_First_Last.txt",
        "checksum": null,
        "url": "http://localhost:10000/devstoreaccount1/et-api-test-container/2Qnar7HebG8wtU7HrUqxjLPP?sp=r&sv=2016-05-31&se=2019-06-12T07%3A46%3A47Z&rscd=inline%3B+filename%3D%22et1_first_last.pdf%22%3B+filename*%3DUTF-8%27%27et1_first_last.pdf&rsct=application%2Fpdf&sr=b&sig=qcUQ4gonbWKjaUXsNQmRdSnR8wAsN%2FvpVwLgM%2FJFaIU%3D"
      }
    ]


=end
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
