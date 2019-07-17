class ExportMultiplesWorker
  include Sidekiq::Worker

  def perform(ccd_data, case_type_id, service: ExportMultipleClaimsService.new)
    data = service.export(ccd_data, case_type_id)
    Sidekiq.redis { |r| r.lpush("BID-#{bid.bid}-references", data.dig('case_data', 'ethosCaseReference')) }
  end
end
