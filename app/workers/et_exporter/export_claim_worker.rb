module EtExporter
  class ExportClaimWorker
    include Sidekiq::Worker

    def perform(json)
      logger.debug "---------------------------------------------------------------------------------------------------------"
      logger.debug "- THIS IS THE JSON THAT HAS COME FROM THE API                                                           -"
      logger.debug "-                                                                                                       -"
      logger.debug "---------------------------------------------------------------------------------------------------------"

      logger.debug JSON.pretty_generate(JSON.parse(json))
    end
  end
end
