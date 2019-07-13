class MultiplesSupervisorService

  # Initialises a group, giving it a name and a target count.  The group is not
  # complete until this number has arrived.
  # @param [String] group_name A unique name to identify this group of claims
  # @param [Integer] count The number of claims to expect in this group
  def self.supervise(group_name:, count:)

  end

  # Queues and supervises a case to go to CCD
  # @param [Hash] data The data ready to go to ccd
  # @param [String] group_name The group name previously setup using supervise
  def self.add_job(data, group_name:)

  end
end
