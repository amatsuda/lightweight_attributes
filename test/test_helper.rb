# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'rails'
require "lightweight_attributes"
require 'active_record'
require 'active_record/railtie'

require "minitest/autorun"

ENV['DATABASE_URL'] = 'sqlite3::memory:'

module TestApp
  Application = Class.new(Rails::Application) do
    config.eager_load = false
    config.active_support.deprecation = :log
  end.initialize!
end
