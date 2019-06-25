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

    def read_attribute_before_type_cast(*)
      if LightweightAttributes::AttributeSet === @attributes
        @attributes = self.class.attributes_builder.build_original_from_database @attributes.raw_attributes, @attributes.additional_types
      end

      super
    end

    def attributes_before_type_cast
      if LightweightAttributes::AttributeSet === @attributes
        @attributes = self.class.attributes_builder.build_original_from_database @attributes.raw_attributes, @attributes.additional_types
      end

      super
    end

    private

    if (::ActiveRecord::VERSION::MAJOR == 5) && (::ActiveRecord::VERSION::MINOR < 2)
      def mutation_tracker
        if LightweightAttributes::AttributeSet === @attributes
          @attributes = self.class.attributes_builder.build_original_from_database @attributes.raw_attributes, @attributes.additional_types
        end

        super
      end
    else
      def mutations_from_database
        if LightweightAttributes::AttributeSet === @attributes
          @attributes = self.class.attributes_builder.build_original_from_database @attributes.raw_attributes, @attributes.additional_types
        end

        super
      end
    end

    def attribute_came_from_user?(*)
      false
    end

    def forget_attribute_assignments
      # do nothing
    end
  end
end
