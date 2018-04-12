# frozen_string_literal: true

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
  end
end
