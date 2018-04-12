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
        LightweightAttributes::AttributeSet.new values
      end
    end
  end
end
