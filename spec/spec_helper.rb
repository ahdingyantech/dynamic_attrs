require 'rspec'
require 'bundler/setup'
require 'dynamic_attrs'
require 'factory_girl'
FactoryGirl.find_definitions

ROOT = Pathname(File.expand_path(File.join(File.dirname(__FILE__), '..')))

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
    t.string  :value
  end unless table_exists?(:dynamic_attr)
  
  add_index :dynamic_attrs, [:owner_id, :owner_type]
  add_index :dynamic_attrs, [:name, :field]
end

class Owner < ActiveRecord::Base
end
