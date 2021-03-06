# frozen_string_literal: true

module LightweightAttributes
  module BaseMethods
    # LightweightAttributes does not accept write_attribute.
    # If any write_attribute attempt was made, it switches the whole attributes instance to the AR default attributes.
    if (::ActiveRecord::VERSION::MAJOR == 5) && (::ActiveRecord::VERSION::MINOR < 2)
      def write_attribute(*)
        if LightweightAttributes::AttributeSet === @attributes
          @attributes = self.class.attributes_builder.build_original_from_database @attributes.raw_attributes, @attributes.additional_types
        end

        super
      end

      def raw_write_attribute(*)
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

    def read_attribute_before_type_cast(attr_name)
      if LightweightAttributes::AttributeSet === @attributes
        @attributes.raw_attributes[attr_name.to_s]
      else
        super
      end
    end

    def attributes_before_type_cast
      if LightweightAttributes::AttributeSet === @attributes
        @attributes.raw_attributes
      else
        super
      end
    end

    private

    # LightweightAttributes does not support dirty tracking.
    # If any dirty tracking attempt was made, it switches the whole attributes instance to the AR default attributes.
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
      if LightweightAttributes::AttributeSet === @attributes
        false
      else
        super
      end
    end

    # lightweight_attributes doesn't know anything about assignments already.
    if (::ActiveRecord::VERSION::MAJOR == 5) && (::ActiveRecord::VERSION::MINOR == 0)
      def store_original_attributes
        super unless LightweightAttributes::AttributeSet === @attributes
      end
    else
      def forget_attribute_assignments
        super unless LightweightAttributes::AttributeSet === @attributes
      end
    end
  end
end
