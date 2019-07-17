class ExportMultiplesHeaderWorker
  include Sidekiq::Worker

  def perform(primary_reference, case_references, case_type_id, service: ExportMultipleClaimsService.new)
    service.export_header(primary_reference, case_references, case_type_id)
  end
end
