json.set! "data" do
  json.set! "caseAssignee", "Bristol"
  json.set! "caseType", "Single"
  json.set! "claimantIndType" do
    json.set! "claimant_title1", claim.dig('primary_claimant', 'title')
    json.set! "claimant_first_names", claim.dig('primary_claimant', 'first_name')
    json.set! "claimant_initials", nil
    json.set! "claimant_last_name", claim.dig('primary_claimant', 'last_name')
    json.set! "claimant_date_of_birth", claim.dig('primary_claimant', 'date_of_birth')
    json.set! "claimant_gender", claim.dig('primary_claimant', 'gender')
    json.set! "claimant_gender", claim.dig('primary_claimant', 'gender')
    json.set! "claimant_fax_number", nil
  end
  json.set! "claimantType" do
    json.set! "claimant_addressUK" do
      json.set! "AddressLine1", claim.dig('primary_claimant', 'address', 'building')
      json.set! "AddressLine2", claim.dig('primary_claimant', 'address', 'street')
      json.set! "PostTown", claim.dig('primary_claimant', 'address', 'locality')
      json.set! "County", claim.dig('primary_claimant', 'address', 'county')
      json.set! "PostCode", claim.dig('primary_claimant', 'address', 'post_code')
      json.set! "Country", claim.dig('primary_claimant', 'address', 'country')
    end
    json.set! "claimant_phone_number", claim.dig('primary_claimant', 'address_telephone_number')
    json.set! "claimant_mobile_number", claim.dig('primary_claimant', 'mobile_number')
    json.set! "claimant_email_address", claim.dig('primary_claimant', 'email_address')
    json.set! "claimant_contact_preference", claim.dig('primary_claimant', 'contact_preference')
  end
  json.set! "claimantOtherType" do
    json.set! "claimant_disabled", claim.dig('primary_claimant', 'special_needs').present? ? 'Yes' : 'No'
    json.set! "claimant_disabled_details", "My special needs"
  end
  json.set! "representedType" do
    json.set! "if_represented", "No"
  end
  json.set! "receiptDate", "2017-01-01"
  json.set! "feeGroupReference", '2220000000100'
  json.set! "respondentType" do
    json.set! "respondent_name", nil
    json.set! "respondent_address" do
      json.set! "AddressLine1", nil
      json.set! "AddressLine2", nil
      json.set! "AddressLine3", nil
      json.set! "PostTown", nil
      json.set! "County", nil
      json.set! "PostCode", nil
      json.set! "Country", nil
    end
    json.set! "respondent_phone1", nil
    json.set! "respondent_phone2", nil
    json.set! "respondent_fax", nil
    json.set! "respondent_email", nil
    json.set! "respondent_contact_preference", ""
  end
  json.set! "respondentCollection", []
  json.set! "caseNote", "sdsd"
end
json.set! "event" do
  json.set! "id", "initiateCase"
  json.set! "summary", ""
  json.set! "description", ""
end
json.set! "event_token", event_token
json.set! "ignore_warning", false
json.set! "draft_id", nil
