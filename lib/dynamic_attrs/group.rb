class DynamicAttr < ActiveRecord::Base
  class Group
    attr_reader :owner, :name, :dirty_records, :updater

    def initialize(owner, name, fields: {}, updater: nil)
      @name    = name
      @owner   = owner
      @fields  = fields
      @updater = updater
      @dirty_records = {}
    end

    class UndefinedAccessor < NoMethodError; end

    delegate :where,  to: :relation
    delegate :build,  to: :relation
    delegate :create, to: :relation

    def relation
      owner.dynamic_attrs.where(name: name)
    end

    def set(field, value)
      record = _get_record(field)
      record.value = value.to_s
      self.dirty_records[field] = record
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

    def fields
      updater ? @fields.merge!(updater.call) : @fields
    end

  private

    def _get_record(field)
      raise UndefinedAccessor.new if fields[field].blank?
      relation.find_by_field(field) || build(field: field)
    end
 
    def _get_type(field)
      DAType.dispatch(fields[field])
    end
  end
end
