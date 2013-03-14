class DynamicAttr < ActiveRecord::Base
  module Owner
    def self.included(base)
      base.send :extend,  ClassMethods
    end

    module ClassMethods
      def has_dynamic_attrs(name, fields: {})
        has_many :dynamic_attrs, as: :owner, conditions: {:name => name}
        before_save {|r| r.send(name).save}

        define_method name do
          instance_variable_get("@#{name}") ||
          instance_variable_set("@#{name}", DynamicAttr::Group.new(self, name, fields: fields))
        end

        define_method "#{name}_where" do |field, value|
          self.send(name).where(field: field, value: value)
        end

        fields.keys.each do |field|
          define_method "#{name}_#{field}" do
            self.send(name).get(field)
          end

          define_method "#{name}_#{field}=" do |value|
            self.send(name).set(field, value)
          end
        end
      end
    end
  end
end
