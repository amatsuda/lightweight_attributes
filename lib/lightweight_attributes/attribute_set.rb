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
      @attributes[name] ||= begin
        type = @types[name]
        ActiveModel::Type::String === type ? @raw_attributes[name] : type.deserialize(@raw_attributes[name])
      end
    end

    def to_hash
      @raw_attributes.each do |k, v|
        @attributes[k] ||= @types[k].deserialize v
      end
      @attributes
    end

    private

    attr_reader :attributes
  end
end
