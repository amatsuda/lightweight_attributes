# frozen_string_literal: true

module LightweightAttributes
  module BaseMethods
    def _write_attribute(*)
      if LightweightAttributes::AttributeSet === @attributes
        @attributes = self.class.instance_variable_get(:@_original_attributes_builder).build_from_database self.class.attributes_builder.original_values, self.class.attributes_builder.original_additional_types
      end

      super
    end
  end
end
