class DynamicAttr
  module Owner
    def self.included(base)
      base.send :extend,   ClassMethods
    end

    module ClassMethods

      def has_dynamic_attrs(name, fields: Hash.new)
        has_many :dynamic_attrs, as: :owner, conditions: {:name => name}

        define_method "_#{name}_type_match" do
          fields.inject({}) do |hash, (field, type)|
            hash[field] = {string: String, datetime: DateTime, boolean: [TrueClass, FalseClass], integer: Integer}[type]
            hash
          end
        end

        define_method "_#{name}_type_valid?" do |field, value|
          type = send("_#{name}_type_match")[field]
          type.is_a?(Array) ? type.include?(value.class) : value.is_a?(type)
        end

        define_method "update_#{name}" do |attrs|
          attrs.each do |field, value|
            user.send("#{name}_#{field}=", value)
          end
        end

        define_method name do
          keys = fields.keys

          model = self
          Struct.new(*keys) do
            def fields
              self.to_h.keys
            end

            keys.each do |field|
              define_method field do
                model.send "#{name}_#{field}"
              end

              define_method "#{field}=" do |value|
                model.send "#{name}_#{field}=", value
              end
            end
          end.new
        end

        define_singleton_method "where_#{name}" do |field, value|
          joins(:dynamic_attrs)
            .where(:dynamic_attrs => {owner_type: self.to_s, name: name, field: field, value: value})
        end

        fields.each do |field, type|
          define_method "#{name}_#{field}=" do |value|
            raise DynamicAttr::TypeMismatch.new if !send("_#{name}_type_valid?", field, value)
            relation = DynamicAttr.where(name: name, owner_type: self.class.to_s, owner_id: self.id, field: field)
            attr = relation.first ? relation.first : relation.new
            attr.update_attribute(:value, value.to_s)
            value 
          end

          define_method "#{name}_#{field}" do
            attr = DynamicAttr.where(name: name, owner_type: self.class.to_s, owner_id: self.id, field: field).first
            return if attr.blank?
            Helper.send "_to_#{type}", attr.value
          end

        end

      end
    end

  end
end
