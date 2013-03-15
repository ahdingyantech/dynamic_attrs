class DynamicAttr < ActiveRecord::Base
  module Owner
    def self.included(base)
      base.send :extend,  ClassMethods
      base.send :include, InstanceMethods
    end

    module ClassMethods
      def has_dynamic_attrs(name, fields: {}, updater: nil)
        has_many :dynamic_attrs, as: :owner, conditions: {:name => name}
        before_save {|r| r.send(name).save}

        @dynamic_attrs_names ||= []
        @dynamic_attrs_names << name

        define_method name do
          instance_variable_get("@#{name}") ||
          instance_variable_set("@#{name}", DynamicAttr::Group.new(self, name, fields: fields, updater: updater))
        end

        define_method "#{name}_where" do |field, value|
          self.send(name).where(field: field, value: value)
        end
      end

      def dynamic_attrs_names
        @dynamic_attrs_names
      end
    end

    module InstanceMethods
      def method_missing(meth, *args, &block)
        getter_regexps = self.class.dynamic_attrs_names.map {|name| /^(#{name})_([^=]*)$/}
        setter_regexps = self.class.dynamic_attrs_names.map {|name| /^(#{name})_(.*)=$/}

        case meth
        when *getter_regexps then self.send($1).get($2.to_sym)
        when *setter_regexps then self.send($1).set($2.to_sym, args[0])
        else super
        end
      end
    end
  end
end
