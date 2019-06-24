# frozen_string_literal: true

require 'rails'
require 'active_record'
require 'active_record/railtie'
require 'memory_profiler'

ENV['RAILS_ENV'] = 'production'
ENV['DB'] ||= 'mysql'
ENV['RECORDS'] ||= '10000'

require_relative 'test/dummy_app'

class Model < ActiveRecord::Base; end

Class.new(ActiveRecord::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[5.0] : ActiveRecord::Migration) do
  def self.up
    create_table :models do |t|
      t.string :col1; t.string :col2; t.string :col3; t.string :col4; t.string :col5; t.string :col6; t.string :col7; t.string :col8; t.string :col9
    end
  end
end.up

ENV['RECORDS'].to_i.times do |i|
  Model.create! col1: 'hello, world!', col2: 'hello, world!', col3: 'hello, world!', col4: 'hello, world!', col5: 'hello, world!', col6: 'hello, world!', col7: 'hello, world!', col8: 'hello, world!', col9: 'hello, world!'
end

#copied from AR 5.2.3 querying.rb
# def find_by_sql(sql, binds = [], preparable: nil, &block)
def measure(benchmarker)
  result_set = Model.connection.select_all(Model.all.arel, '', [], preparable: false)
  column_types = result_set.column_types.dup
  Model.attribute_types.each_key { |k| column_types.delete k }

  # warming up
  records = result_set.map {|record| Model.instantiate(record, column_types) }
  records.each {|r| v = r.id; v = r.col1; v = r.col2; v = r.col3; v = r.col4; v = r.col5; v = r.col6; v = r.col7; v = r.col8; v = v = r.col9 }

  result = benchmarker.call do
    records = result_set.map {|record| Model.instantiate(record, column_types) }
    records.each {|r| v = r.id; v = r.col1; v = r.col2; v = r.col3; v = r.col4; v = r.col5; v = r.col6; v = r.col7; v = r.col8; v = v = r.col9 }
  end

  result.is_a?(MemoryProfiler::Results) ? result.pretty_print : pp(result)
end

benchmark = case ARGV[0]
when 'time'
  ->(&b) { now = Time.now; b.call; Time.now - now }
when 'methods'
  ->(&b) do
    [].tap do |methods|
      TracePoint.new(:call) {|t| methods << "#{t.defined_class}##{t.method_id}" }.enable { b.call }
    end.tally
  end
else
  ->(&b) { MemoryProfiler.report(&b) }
end


GC.disable

puts "#{'*' * 30} ActiveModel::AttributeSet #{'*' * 30}"

measure benchmark

puts; puts; puts "#{'*' * 30} LightweightAttributes #{'*' * 30}"

require_relative 'lib/lightweight_attributes'
require_relative 'lib/lightweight_attributes/base_class_methods'

Model.instance_variable_set :@attributes_builder, nil
LightweightAttributes::BaseClassMethods.instance_method(:attributes_builder).bind(Model).call

measure benchmark
