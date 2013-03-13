class DynamicAttr < ActiveRecord::Base
  class Group
    attr_reader :owner, :name

    def initialize(owner, name, fields: {})
      @name     = name
      @owner    = owner

      define_singleton_method :relation do
        DynamicAttr.where(name: self.name)
      end

      self.add_fields fields
    end

    def add_fields(fields)
      fields.each do |field, data_type|
        self.relation.create owner: self.owner, field: field, data_type: data_type.to_s

        define_singleton_method "#{field}=" do |value|
          _set(field, value)
        end

        define_singleton_method "#{field}" do
          _get(field)
        end

      end.keys
    end

    delegate :where, to: :relation

    def fields
      self.relation.pluck(:field).map(&:to_sym)
    end

    def update_attrs(fields = {})
      fields.each do |field, value|
        _set(field, value)
      end
    end

  private

    def _set(field, value)
      _get_record(field).update_attribute :value, value.to_s
      value
    end

    def _get(field)
      raw = _get_record(field).value
      raw && _get_field_da_type(field).new(raw).to_ruby
    end

    def _get_record(field)
      self.relation.find_by_field(field)
    end
 
    def _get_field_da_type(field)
      _get_record(field).data_type.constantize
    end
 end
end
