# frozen_string_literal: true

module LightweightAttributes
  class AttributeSet
    class Builder
      attr_reader :types, :default_attributes

      def initialize(types, default_attributes = {})
        @types = types
        @default_attributes = default_attributes
      end

      def build_from_database(values = {}, _additional_types = {})
        casted = values.each_with_object({}) {|(col, val), h| h[col] = @types[col].deserialize val }
        LightweightAttributes::AttributeSet.new casted
      end
    end
  end
end
