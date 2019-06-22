# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'rails'
require "lightweight_attributes"
require 'active_record'
require 'active_record/railtie'

require "minitest/autorun"
require 'byebug'

ENV['RAILS_ENV'] = 'test'
ENV['DB'] ||= 'sqlite3'

require_relative 'dummy_app'
