# frozen_string_literal: true

module LightweightAttributes
  module BaseMethods
    def _write_attribute(*)
      if LightweightAttributes::AttributeSet === @attributes
        @attributes = self.class.attributes_builder.build_original_from_database
      end

      super
    end
  end
end
