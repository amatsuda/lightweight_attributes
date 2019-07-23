# frozen_string_literal: true

require_relative 'attribute_set/builder'

module LightweightAttributes
  class AttributeSet
    attr_reader :raw_attributes, :additional_types

    delegate :each_value, :fetch, :except, :[], :[]=, to: :@attributes
    delegate :key?, :keys, to: :@raw_attributes

    def initialize(raw_attributes, types, additional_types)
      @raw_attributes = raw_attributes
      @types = types
      @additional_types = additional_types
      @attributes = {}
      def @attributes.delegate_hash
        self
      end
      @sorted = true
    end

    # Lazily cast the attribute from database when being fetched.
    # For String attributes, directly returns the raw value without creating a new copy.
    def fetch_value(name)
      return @attributes[name] if @attributes.key? name

      @sorted = false unless @attributes.empty?
      type = @types[name]
      @attributes[name] = ActiveModel::Type::String === type ? @raw_attributes[name] : type.deserialize(@raw_attributes[name])
    end

    # For Model#accessed_fields
    def accessed
      sort_attributes!.keys
    end

    # Cast all attributes, then return the result.
    def to_hash
      @raw_attributes.each do |k, v|
        unless @attributes.key? k
          @sorted = false unless @attributes.empty?
          type = @types[k]
          @attributes[k] = ActiveModel::Type::String === type ? @raw_attributes[k] : type.deserialize(v)
        end
      end

      sort_attributes!
    end

    def reset(key)
      @attributes[key] = nil
    end

    private

    attr_reader :attributes

    def sort_attributes!
      return @attributes if @sorted

      @sorted = true
      @attributes = @raw_attributes.each_key.with_object({}) do |k, h|
        h[k] = @attributes[k] if @attributes.key? k
      end
    end
  end
end
