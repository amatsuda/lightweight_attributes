# frozen_string_literal: true

module LightweightAttributes
  class AttributeSet
    class Builder
      attr_reader :types, :default_attributes

      def initialize(types, default_attributes = {}, original_attributes_builder)
        @types = types
        @default_attributes = default_attributes
        @original_attributes_builder = original_attributes_builder
      end

      def build_from_database(values = {}, _additional_types = {})
        @original_values = values
        @original_additional_types = _additional_types

        LightweightAttributes::AttributeSet.new values, @types, _additional_types
      end

      def build_original_from_database
        @original_attributes_builder.build_from_database @original_values, @original_additional_types
      end
    end
  end
end
