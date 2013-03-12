class DynamicAttr < ActiveRecord::Base
  module Owner
    def self.included(base)
      base.send :extend,  ClassMethods
      base.send :include, InstanceMethods
    end

    module ClassMethods
      def has_dynamic_attrs(name, fields: Hash.new)
        @_dynamic_attrs ||= Hash.new
        @_dynamic_attrs[name.to_sym] = fields

        has_many :dynamic_attrs, as: :owner, conditions: {:name => name}

        fields.keys.each do |field|
          define_method "#{name}_#{field}=" do |value|
            set_field_value_from_name(name, field, value)
          end

          define_method "#{name}_#{field}" do
            get_field_value_from_name(name, field)
          end
        end
      end

      def _dynamic_attrs
        @_dynamic_attrs
      end
    end

    module InstanceMethods
      def _convert_field(name, field, value)
        case self.class._dynamic_attrs[name.to_sym][field]
        when :string   then value.to_s
        when :integer  then value.to_i
        when :boolean  then {true: true, false: false}[value.to_s.to_sym]
        when :datetime then value.to_datetime
        end
      end

      def get_field_value_from_name(name, field)
        attr = DynamicAttr.where(name: name, owner_type: self.class.to_s, owner_id: self.id, field: field).first

        return if attr.blank?
        _convert_field(name, field, attr.value)
      end

      def set_field_value_from_name(name, field, value)
        converted_value = _convert_field(name, field, value)
        relation        = DynamicAttr.where(name: name, owner_type: self.class.to_s, owner_id: self.id, field: field)
        attr            = relation.first ? relation.first : relation.new

        attr.update_attribute :value, converted_value.to_s
        converted_value
      end

    end

  end
end
