# frozen_string_literal: true

module LightweightAttributes
  class Railtie < ::Rails::Railtie
    initializer 'lightweight_attributes' do
      require_relative 'base_class_methods'

      ActiveSupport.on_load :active_record do
        extend LightweightAttributes::BaseClassMethods
        prepend LightweightAttributes::BaseMethods
      end
    end
  end
end
