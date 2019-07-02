# frozen_string_literal: true

module LightweightAttributes
  class AttributeSet
    class Builder
      attr_reader :types, :default_attributes

      def initialize(types, default_attributes, original_attributes_builder)
        @types = types
        @default_attributes = default_attributes
        @original_attributes_builder = original_attributes_builder
      end

      # Build our own lightweight attribute set.
      def build_from_database(values, _additional_types)
        LightweightAttributes::AttributeSet.new values, @types, _additional_types
      end

      def build_original_from_database(values, additional_types)
        @original_attributes_builder.build_from_database values, additional_types
      end
    end
  end
end
