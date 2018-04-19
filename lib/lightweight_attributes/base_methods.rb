# frozen_string_literal: true

module LightweightAttributes
  module BaseMethods
    def attributes_before_type_cast
      @attributes
    end

    def read_attribute_before_type_cast(attr_name)
      @attributes[attr_name]
    end

    def _write_attribute(attr_name, value)
      was = @attributes[attr_name]
      changed_attributes[attr_name] = was unless changed_attributes.key? attr_name
      value = self.class.attribute_types[attr_name].cast value
      @attributes[attr_name] = value
    end

    # AR 5.0
    private def write_attribute_with_type_cast(attr_name, value, _should_type_cast)
      _write_attribute attr_name, value
    end

    #NOTE: Should be true for user posted Time Hash, but who cares?
    def attribute_came_from_user?(_attribute_name)
      false
    end

    def will_save_change_to_attribute?(attr_name, **options)
      changed_attributes.key? attr_name
    end

    def attribute_in_database(attr_name)
      changed_attributes.key?(attr_name) ? changed_attributes[attr_name] : @attributes[attr_name]
    end

    def changes_to_save
      changed_attributes.each_with_object({}) {|(k, v), h| h[k] = [v, @attributes[k]]}
    end

    def changed_attribute_names_to_save
      changed_attributes.keys
    end

    def has_changes_to_save?
      changed_attributes.any?
    end

    def changed_attributes
      @changed_attributes ||= {}
    end

    def changed?(attr_name, **_options)
      changed_attributes.key? attr_name
    end

    private def forget_attribute_assignments
      @changed_attributes.each do |k, v|
        @attributes[k] = v
      end
      @changed_attributes.clear
    end

    # AR 5.0
    def store_original_attributes
      forget_attribute_assignments
    end
  end
end
