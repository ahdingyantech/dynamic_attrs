class DynamicAttr < ActiveRecord::Base
  module Owner
    def self.included(base)
      base.send :extend,  ClassMethods
    end

    module ClassMethods
      def has_dynamic_attrs(name, fields: {})
        @_dynamic_attrs ||= Hash.new
        @_dynamic_attrs[name.to_sym] = fields

        has_many :dynamic_attrs, as: :owner, conditions: {:name => name}

        define_method name do
          DynamicAttr::Group.new(self, name, fields: fields)
        end
      end
    end
  end
end
