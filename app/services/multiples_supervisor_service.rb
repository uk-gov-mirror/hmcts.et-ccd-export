class MultiplesSupervisorService

  # Initialises a group, giving it a name and a target count.  The group is not
  # complete until this number has arrived.
  # @param [String] group_name A unique name to identify this group of claims
  # @param [Integer] count The number of claims to expect in this group
  def self.supervise(group_name:, count:, success_callback:, failure_callback:, adapter: default_adapter)
    adapter.create_group(group_name, count: count, success_callback: success_callback, failure_callback: failure_callback)
  end

  # Queues and supervises a case to go to CCD
  # @param [Hash] data The data ready to go to ccd
  # @param [String] group_name The group name previously setup using supervise
  def self.add_job(data, group_name:, adapter: default_adapter, worker: ExportMultiplesWorker)
    jid = worker.perform_async group_name, data, success_callback: "#{name}.on_job_success",
                                                 failure_callback: "#{name}.on_job_failure",
                                                 retry_callback: "#{name}.on_job_retry"
    adapter.add_job(group_name, jid, 'enqueued')
  end

  def self.on_job_success(group_name, jid, status, application_data, adapter: default_adapter)
    adapter.update_job(group_name, jid, status, application_data)
    progress_update(group_name, adapter: adapter)
  end

  def self.progress_update(group_name, adapter: default_adapter)
    group = adapter.group(group_name)
    if group['jobs'].keys.length == group.dig('meta', 'count')
      klass, method = group.dig('meta', 'success_callback').split('.')
      "::#{klass}".safe_constantize.send(method.to_sym)
    end
  end

  def self.default_adapter
    "::MultiplesSupervisorService::#{config[:type].camelize}Adapter".safe_constantize
  end

  def self.config
    Rails.application.config.multiples_supervisor_adapter
  end

  class RedisAdapter
    def self.create_group(group_name, count:, success_callback:, failure_callback: )

    end

    def self.add_job(group_name, jid, status)

    end

    def self.update_job(group_name, jid, status, application_data)

    end

    def self.group(group_name)

    end
  end

  # To be used in testing only -will not work across processes
  class MemoryAdapter
    Thread.current[:in_memory_store] = {}
    def self.create_group(group_name, count:, success_callback:, failure_callback:)
      Thread.current[:in_memory_store][group_name] = {'meta' => {'count' => count, 'success_callback' => success_callback, 'failure_callback' => failure_callback}, 'jobs' => {}}
    end

    def self.add_job(group_name, jid, status)
      Thread.current[:in_memory_store][group_name]['jobs'][jid] = {'status' => status}
    end

    def self.update_job(group_name, jid, status, application_data)
      Thread.current[:in_memory_store][group_name]['jobs'][jid].merge!('status' => status, 'application_data' => application_data)
    end

    def self.group(group_name)
      Thread.current[:in_memory_store][group_name]
    end
  end
end
