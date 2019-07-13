class ExportMultipleClaimsService
  def initialize(supervisor: MultiplesSupervisorService)
    self.supervisor = supervisor
  end

  def call(export)
    supervisor.supervise group_name: export.dig('resource', 'reference'), count: export.dig('resource', 'secondary_claimants').length + 1
    supervisor.add_job MultipleClaimsPresenter.present(export['resource'], claimant: export['primary_claimant'], lead_claimant: true), group_name: export.dig('resource', 'reference')
    export.dig('resource', 'secondary_claimants').each do |claimant|
      supervisor.add_job MultipleClaimsPresenter.present(export['resource'], claimant: claimant, lead_claimant: false), group_name: export.dig('resource', 'reference')
    end
  end

  private

  attr_accessor :supervisor
end
