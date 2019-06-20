module OptionalAcasExemptionHelper
  def optional_acas_exemption(exemption)
    case exemption
    when 'joint_claimant_has_acas_number' then
      'Another person'
    when 'acas_has_no_jurisdiction' then
      'No Power'
    when 'employer_contacted_acas' then
      'Employer already in touch'
    when 'interim_relief' then
      'Unfair Dismissal'
    end
  end
end
