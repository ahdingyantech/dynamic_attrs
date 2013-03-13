require 'rspec'
require 'bundler/setup'
require 'dynamic_attrs'
require 'factory_girl'
require 'database_cleaner'
FactoryGirl.find_definitions

ActiveRecord::Base.logger = ActiveSupport::BufferedLogger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Base.connection.create_table :owners if ActiveRecord::Base.connection.table_exists? :owners

ActiveRecord::Schema.define do
  create_table :owners unless table_exists?(:owners)

  create_table :dynamic_attrs do |t|
    t.integer :owner_id,   :null => false
    t.string  :owner_type, :null => false
    t.string  :name,       :null => false
    t.string  :field,      :null => false
    t.string  :data_type
    t.string  :value
  end unless table_exists?(:dynamic_attr)
end

class Owner < ActiveRecord::Base
  include DynamicAttr::Owner
end

RSpec.configure do |config|
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  config.include FactoryGirl::Syntax::Methods
  config.order = "random"

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
