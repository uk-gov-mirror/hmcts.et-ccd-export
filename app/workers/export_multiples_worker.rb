class ExportMultiplesWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'external_system_ccd_multiples'

  def perform(ccd_data, case_type_id, primary = false, service: ExportMultipleClaimsService.new)
    data = service.export(ccd_data, case_type_id)
    if primary
      Sidekiq.redis { |r| r.lpush("BID-#{bid}-references", data.dig('case_data', 'ethosCaseReference')) }
    else
      Sidekiq.redis { |r| r.rpush("BID-#{bid}-references", data.dig('case_data', 'ethosCaseReference')) }
    end
  end
end
