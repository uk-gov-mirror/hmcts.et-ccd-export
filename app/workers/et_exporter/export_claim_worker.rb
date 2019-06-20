require 'sidekiq'
module EtExporter
  class ExportClaimWorker
    include Sidekiq::Worker
    
    def perform(json)
      puts "---------------------------------------------------------------------------------------------------------"
      puts "- THIS IS THE JSON THAT HAS COME FROM THE API                                                           -"
      puts "-                                                                                                       -"
      puts "---------------------------------------------------------------------------------------------------------"
      
      puts JSON.pretty_generate(JSON.parse(json))
      
    end
  end
end
