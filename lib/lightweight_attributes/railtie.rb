# frozen_string_literal: true

module LightweightAttributes
  class Railtie < ::Rails::Railtie
    initializer 'lightweight_attributes' do
      ActiveSupport.on_load :active_record do
        extend LightweightAttributes::BaseClassMethods
        prepend LightweightAttributes::BaseMethods
      end
    end
  end
end
