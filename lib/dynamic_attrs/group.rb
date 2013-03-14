class DynamicAttr < ActiveRecord::Base
  class Group
    attr_reader :owner, :name, :dirty_records
    attr_accessor :fields

    def initialize(owner, name, fields: {})
      @name     = name
      @owner    = owner
      @fields   = fields
      @dirty_records = {}
    end

    delegate :where,  to: :relation
    delegate :count,  to: :relation
    delegate :new,    to: :relation
    delegate :create, to: :relation
    delegate :all,    to: :relation
    delegate :count,  to: :relation

    def relation
      owner.dynamic_attrs.where(name: name)
    end

    def set(field, value)
      record = _get_record(field)
      record.value = value.to_s
      @dirty_records[field] = record
      value
    end

    def get(field)
      record = self.dirty_records[field] || _get_record(field)
      record.value && _get_type(field).new(record.value).to_ruby
    end

    def save
      self.dirty_records.values.each(&:save)
      @dirty_records = {}
    end

  private

    def _get_record(field)
      self.relation.find_by_field(field) || self.new(field: field)
    end
 
    def _get_type(field)
      DAType.dispatch(self.fields[field])
    end
  end
end
