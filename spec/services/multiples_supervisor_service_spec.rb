require 'rails_helper'
RSpec.describe MultiplesSupervisorService do
  subject(:service) { described_class }

  let(:mock_adapter) { class_spy('::MultipleSupervisorService::RedisAdapter') }

  describe '.supervise' do
    it 'asks the adapter to create a new group' do
      # Act - call the service
      service.supervise(group_name: 'my_group', count: 10, success_callback: 'MockCaller.mock_success', failure_callback: 'MockCaller.mock_failure', adapter: mock_adapter)

      # Assert - All this does is records this information
      expect(mock_adapter).to have_received(:create_group).with('my_group', count: 10, success_callback: 'MockCaller.mock_success', failure_callback: 'MockCaller.mock_failure')
    end
  end

  describe '.add_job' do
    let(:mock_worker_class) do
      instance = nil
      self.class::MockWorker = Class.new do
        include Sidekiq::Worker
        define_singleton_method(:new) do
          instance
        end

        def perform(*args); end
      end
      instance = mock_worker
      self.class::MockWorker
    end
    let(:mock_worker) { instance_spy(self.class::MockWorker) }

    before { Sidekiq::Queues.clear_all }
    it 'schedules a worker to perform the job' do
      # Act - Call the service
      action = -> { service.add_job({'some' => 'data'}, group_name: 'my_group', adapter: mock_adapter) }

      # Assert - Ensure the job was scheduled
      expect(action).to change(ExportMultiplesWorker.jobs, :size).by(1)
    end

    it 'schedules a worker with the callback specified' do
      # Act - Call the service
      service.add_job({'some' => 'data'}, group_name: 'my_group', adapter: mock_adapter, worker: mock_worker_class)
      mock_worker_class.drain

      # Assert - Ensure the job was scheduled with the callback specified
      expect(mock_worker).to have_received(:perform).with('my_group', {'some' => 'data'}, 'success_callback' => 'MultiplesSupervisorService.on_job_success', 'failure_callback' => 'MultiplesSupervisorService.on_job_failure', 'retry_callback' => 'MultiplesSupervisorService.on_job_retry')
    end

    it 'schedules a worker with the group specified' do
      # Act - Call the service
      service.add_job({'some' => 'data'}, group_name: 'my_group', adapter: mock_adapter)

      # Assert - Ensure the job was scheduled with the data specified
      expect(ExportMultiplesWorker.jobs.last['args'].first).to eql('my_group')
    end

    it 'schedules a worker with the data specified' do
      # Act - Call the service
      service.add_job({'some' => 'data'}, group_name: 'my_group', adapter: mock_adapter)

      # Assert - Ensure the job was scheduled with the data specified
      expect(ExportMultiplesWorker.jobs.last['args'][1]).to eql({'some' => 'data'})
    end

    it 'records the job using the adapter' do
      # Act - Call the service
      service.add_job({'some' => 'data'}, group_name: 'my_group', adapter: mock_adapter)

      # Assert - Ensure the adapter was called to record that the job was enqueued
      expect(mock_adapter).to have_received(:add_job).with('my_group', instance_of(String), 'enqueued')
    end
  end

  describe '.on_job_success' do
    let(:mock_caller_class) do
      self.class::MockCaller = Class.new do
        define_singleton_method(:success) {}
        define_singleton_method(:failure) {}
      end
      self.class::MockCaller
    end
    it 'records the success and any application data using the adapter' do
      # Act - Call the service
      service.on_job_success('my_group', 'my_jid', 'success', {'application' => 'data'}, adapter: mock_adapter)

      # Assert - Should have called update_job
      expect(mock_adapter).to have_received(:update_job).with('my_group', 'my_jid', 'success', {'application' => 'data'})
    end

    it 'calls the success callback specified in the supervise method when all jobs are done' do
      # Setup the state of the mock adapter to simulate 3 jobs being supervised, 2 of them have been successful
      #  and this test is for the third one to come in successfully
      expect(mock_adapter).to receive(:group).
        with('my_group').
        and_return \
          'meta' => {
            'count' => 3,
            'success_callback' => "#{mock_caller_class.name}.success",
            "failure_callback" => "#{mock_caller_class.name}.failure"
          },
          'jobs' => {
            'jid1' => {'status' => 'success', 'data' => {}},
            'jid2' => {'status' => 'success', 'data' => {}},
            'jid3' => {'status' => 'enqueued'}
          }
      allow(mock_caller_class).to receive(:success)

      # Act - Call for the 3rd time
      service.on_job_success('my_group', 'jid3', 'success', {'application' => 'data'}, adapter: mock_adapter)

      # Assert - Make sure the success callback was called
      expect(mock_caller_class).to have_received(:success).with('my_group', {'application' => 'data'})
    end

  end

  describe '.on_job_failure' do

  end

  describe '.on_job_retry'
end
