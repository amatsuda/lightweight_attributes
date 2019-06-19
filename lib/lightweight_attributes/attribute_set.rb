# frozen_string_literal: true

require_relative 'attribute_set/builder'

module LightweightAttributes
  class AttributeSet
    delegate :each_value, :fetch, :except, :[], :[]=, :key?, :keys, to: :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def fetch_value(name)
      self[name]
    end

    def to_hash
      @attributes
    end

    private

    attr_reader :attributes
  end
end
