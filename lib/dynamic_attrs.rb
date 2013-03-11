require 'active_record'
require 'rails/generators/base'

class DynamicAttr < ActiveRecord::Base
  belongs_to :owner, polymorphic: true

  class TypeMismatch < Exception;end
end

require 'dynamic_attrs/helper'
require 'dynamic_attrs/owner'
