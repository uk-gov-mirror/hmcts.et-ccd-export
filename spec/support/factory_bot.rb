require_relative './json_factory_nodes'
require 'active_support/core_ext/object/blank'
require 'factory_bot'
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
