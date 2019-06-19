# frozen_string_literal: true

module LightweightAttributes
  class AttributeSet
    class Builder
      attr_reader :types, :default_attributes, :original_values, :original_additional_types

      def initialize(types, default_attributes = {})
        @types = types
        @default_attributes = default_attributes
      end

      def build_from_database(values = {}, _additional_types = {})
        @original_values = values
        @original_additional_types = _additional_types

        casted = values.each_with_object({}) {|(col, val), h| h[col] = @types[col].deserialize val }
        LightweightAttributes::AttributeSet.new casted
      end
    end
  end
end
