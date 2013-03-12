require 'active_record'
require 'dynamic_attrs/owner'

class DynamicAttr < ActiveRecord::Base
  belongs_to :owner, polymorphic: true

  class TypeMismatch < Exception; end
end
