# frozen_string_literal: true

require_relative 'attribute_set/builder'

module LightweightAttributes
  class AttributeSet
    delegate :each_value, :fetch, :except, :[], :[]=, :key?, :keys, to: :attributes

    def initialize(raw_attributes, types)
      @raw_attributes = raw_attributes
      @types = types
      @attributes = {}
    end

    def fetch_value(name)
      @attributes[name] ||= @types[name].deserialize @raw_attributes[name]
    end

    def to_hash
      @attributes
    end

    private

    attr_reader :attributes
  end
end
