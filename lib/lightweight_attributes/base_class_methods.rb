# frozen_string_literal: true

require_relative 'base_methods'

module LightweightAttributes
  module BaseClassMethods
    def _default_attributes # :nodoc:
      load_schema
      @default_attributes ||= if attributes_to_define_after_schema_loads.empty?
        LightweightAttributes::AttributeSet.new({})
      else
        ActiveModel::AttributeSet.new({})
      end
    end

    def attributes_builder
      if attributes_to_define_after_schema_loads.empty?
        unless defined?(@attributes_builder) && @attributes_builder
          defaults = _default_attributes.except(*(column_names - [primary_key]))
          @attributes_builder = LightweightAttributes::AttributeSet::Builder.new(attribute_types, defaults)
        end
        @attributes_builder
      else
        super
      end
    end

    def load_schema!
      super
      include BaseMethods if attributes_to_define_after_schema_loads.empty?
    end

    #TODO: maybe we need to properly handle other non-nil values
    private def define_default_attribute(name, value, type, from_user:)
      super if attributes_to_define_after_schema_loads.any?

      if value.nil? || (value == ActiveRecord::Attributes::ClassMethods.const_get(:NO_DEFAULT_PROVIDED))
        _default_attributes[name] = nil
      else
        super
      end
    end
  end
end
