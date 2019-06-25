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
    end

    def fetch_value(name)
      @attributes[name] ||= begin
        type = @types[name]
        ActiveModel::Type::String === type ? @raw_attributes[name] : type.deserialize(@raw_attributes[name])
      end
    end

    def to_hash
      @raw_attributes.each do |k, v|
        @attributes[k] ||= ActiveModel::Type::String === type ? @raw_attributes[k] : @types[k].deserialize(v)
      end
      @attributes
    end

    private

    attr_reader :attributes
  end
end
