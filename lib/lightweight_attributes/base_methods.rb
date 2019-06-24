# frozen_string_literal: true

module LightweightAttributes
  module BaseMethods
    if (::ActiveRecord::VERSION::MAJOR == 5) && (::ActiveRecord::VERSION::MINOR < 2)
      def write_attribute(*)
        if LightweightAttributes::AttributeSet === @attributes
          @attributes = self.class.attributes_builder.build_original_from_database @attributes.raw_attributes, @attributes.additional_types
        end

        super
      end
    else
      def _write_attribute(*)
        if LightweightAttributes::AttributeSet === @attributes
          @attributes = self.class.attributes_builder.build_original_from_database @attributes.raw_attributes, @attributes.additional_types
        end

        super
      end
    end

    def attribute_changed?(*)
      if LightweightAttributes::AttributeSet === @attributes
        @attributes = self.class.attributes_builder.build_original_from_database @attributes.raw_attributes, @attributes.additional_types
      end

      super
    end

    if (::ActiveRecord::VERSION::MAJOR == 6) || ((::ActiveRecord::VERSION::MAJOR == 5) && (::ActiveRecord::VERSION::MINOR == 1))
      def attribute_was(*)
        if LightweightAttributes::AttributeSet === @attributes
          @attributes = self.class.attributes_builder.build_original_from_database @attributes.raw_attributes, @attributes.additional_types
        end

        super
      end
    end
  end
end
