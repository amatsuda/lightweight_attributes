# frozen_string_literal: true

require "test_helper"

class LightweightAttributesTest < Minitest::Test
  ActiveRecord::Migration.verbose = false

  def setup
    super
    Object.const_set :Post, Class.new(ActiveRecord::Base)
  end

  def teardown
    super
    Object.send :remove_const, :Post
  end

  def with_attributes(*attrs)
    migration = Class.new(ActiveRecord::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[5.0] : ActiveRecord::Migration) do
      define_singleton_method :up do
        create_table :posts
        attrs.each do |name, type, options|
          add_column :posts, name, type
        end
      end

      def self.down
        drop_table :posts
      end
    end

    migration.up
    yield
  ensure
    migration.down
  end

  def assert_lightweight_attributes(model)
    assert_instance_of LightweightAttributes::AttributeSet, model.instance_variable_get(:@attributes)
  end

  def test_new_with_no_defaults
    with_attributes [:name, :string], [:body, :text], [:posted_at, :datetime], [:category, :integer], [:published, :boolean] do
      p = Post.new
      assert_lightweight_attributes p
      assert_nil p.name
      assert_nil p.body
      assert_nil p.posted_at
      assert_nil p.category
      assert_nil p.published
    end
  end

  def test_new_with_defaults
    now = Time.current
    with_attributes [:name, :string, 'hello'], [:body, :text, 'world'], [:posted_at, :datetime, now], [:category, :integer, 3], [:published, :boolean, true] do
      p = Post.new
      assert_lightweight_attributes p
      assert 'hello', p.name
      assert 'world', p.body
      assert now, p.posted_at
      assert 3, p.category
      assert true, p.published
    end
  end
end
