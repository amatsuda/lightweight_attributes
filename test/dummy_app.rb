# frozen_string_literal: true

module DummyApp
  Application = Class.new(Rails::Application) do
    config.eager_load = false
    config.active_support.deprecation = :log
    config.root = __dir__
  end.initialize!
end

ActiveRecord::Migration.verbose = false

ActiveRecord::Tasks::DatabaseTasks.drop_current 'test'
ActiveRecord::Tasks::DatabaseTasks.create_current 'test'
