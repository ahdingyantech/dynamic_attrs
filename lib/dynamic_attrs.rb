require 'active_record'
require 'dynamic_attrs/owner'
require 'dynamic_attrs/group'
require 'dynamic_attrs/da_type'
Dir[File.dirname(__FILE__) + '/dynamic_attrs/da_type/*.rb'].each {|f| require f}

class DynamicAttr < ActiveRecord::Base
  attr_accessible :field
  belongs_to :owner, polymorphic: true

  class TypeMismatch < Exception; end
end
