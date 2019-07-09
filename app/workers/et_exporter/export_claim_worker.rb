module EtExporter
  class ExportClaimWorker
    include Sidekiq::Worker

    def perform(json)
      logger.debug "---------------------------------------------------------------------------------------------------------"
      logger.debug "- THIS IS THE JSON THAT HAS COME FROM THE API                                                           -"
      logger.debug "-                                                                                                       -"
      logger.debug "---------------------------------------------------------------------------------------------------------"

      parsed_json = JSON.parse(json)
      logger.debug JSON.pretty_generate(parsed_json)
      
      ExportClaimService.new.call(parsed_json) unless ENV.fetch('ET_CCD_SIMULATION', 'false').downcase == 'true'
    end
  end
end
