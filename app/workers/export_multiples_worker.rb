class ExportMultiplesWorker
  include Sidekiq::Worker

  def perform(*)
    test=1
  end
end
