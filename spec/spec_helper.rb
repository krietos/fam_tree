require 'bundler/setup'
Bundler.require(:default, :test)
require './lib/person'
require './lib/child'
require './lib/parent'
require './lib/marriage'
require './lib/relationship'
require './lib/getsreplace'

database_configurations = YAML::load(File.open('./db/config.yml'))
test_configuration = database_configurations['test']
ActiveRecord::Base.establish_connection(test_configuration)

RSpec.configure do |config|
  config.after(:each) do
  end
end
