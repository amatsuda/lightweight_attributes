# frozen_string_literal: true

require "test_helper"

class LightweightAttributesTest < Minitest::Test
  def setup
    super
    Object.const_set :Post, Class.new(ActiveRecord::Base)
  end

  def teardown
    super
    ActiveRecord::Base.clear_all_connections!
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

  def assert_not_lightweight_attributes(model)
    refute_instance_of LightweightAttributes::AttributeSet, model.instance_variable_get(:@attributes)
  end

  def test_new
    with_attributes [:title, :string], [:body, :text], [:posted_at, :datetime], [:category, :integer], [:published, :boolean] do
      p = Post.new
      assert_not_lightweight_attributes p
    end
  end

  def test_reader
    with_attributes [:title, :string], [:body, :text], [:posted_at, :datetime], [:category, :integer], [:published, :boolean] do
      now = Time.current.change(usec: 0)
      if ENV['DB'] == 'sqlite3'
        Post.connection.execute "insert into posts(title, body, posted_at, category, published) values ('hello', 'world', '#{now.to_s(:db)}', 123, 'true')"
      else
        Post.connection.execute "insert into posts(title, body, posted_at, category, published) values ('hello', 'world', '#{now.to_s(:db)}', 123, true)"
      end

      p = Post.last
      assert_lightweight_attributes p
      assert_equal 'hello', p.title
      assert_equal 'world', p.body
      assert_equal now, p.posted_at
      assert_equal 123, p.category
      assert_equal true, p.published
    end
  end

  def test_writer
    with_attributes [:title, :string] do
      Post.connection.execute "insert into posts(title) values ('hello')"

      p = Post.last
      assert_lightweight_attributes p

      p.title = 'updated!'
      assert_equal 'updated!', p.title
      assert_not_lightweight_attributes p
    end
  end

  def test_dirty
    with_attributes [:title, :string] do
      Post.connection.execute "insert into posts(title) values ('hello')"

      p = Post.last
      assert_lightweight_attributes p

      assert_equal 'hello', p.title_was
      assert_not_lightweight_attributes p
    end
  end

  def test_save
    with_attributes [:title, :string] do
      Post.connection.execute "insert into posts(title) values ('hello')"

      p = Post.last
      assert_lightweight_attributes p

      assert_equal true, p.save
      assert_not_lightweight_attributes p
    end
  end

  def test_came_from_user
    with_attributes [:title, :string] do
      Post.connection.execute "insert into posts(title) values ('hello')"

      p = Post.last
      assert_lightweight_attributes p

      assert_equal false, p.title_came_from_user?
      assert_lightweight_attributes p
    end
  end

  def test_to_hash
    with_attributes [:title, :string] do
      Post.connection.execute "insert into posts(title) values ('hello')"

      p = Post.last
      assert_lightweight_attributes p

      title = p.title
      id = p.id
      assert_equal({'id' => id, 'title' => title}, p.attributes.to_hash)
      assert_equal(%w(id title), p.attributes.to_hash.keys)
    end
  end

  def test_accessed_fields
    with_attributes [:title, :string] do
      Post.connection.execute "insert into posts(title) values ('hello')"

      p = Post.last
      assert_lightweight_attributes p

      assert_equal [], p.accessed_fields
      _ = p.title
      assert_equal %w(title), p.accessed_fields
      _ = p.id
      assert_equal %w(id title), p.accessed_fields
    end
  end

  def test_attributes_before_type_cast
    with_attributes [:title, :string] do
      Post.connection.execute "insert into posts(title) values ('hello')"

      p = Post.last
      assert_lightweight_attributes p

      assert_equal({'id' => 1, 'title' => 'hello'}, p.attributes_before_type_cast)
      assert_not_lightweight_attributes p
    end
  end

  def test_read_attribute_before_type_cast
    with_attributes [:title, :string] do
      Post.connection.execute "insert into posts(title) values ('hello')"

      p = Post.last
      assert_lightweight_attributes p

      assert_equal 'hello', p.read_attribute_before_type_cast(:title)
      assert_not_lightweight_attributes p
    end
  end

  def test_clear_changes_information
    with_attributes [:title, :string] do
      Post.connection.execute "insert into posts(title) values ('hello')"

      p = Post.last
      assert_lightweight_attributes p

      assert_nil p.clear_changes_information
      assert_lightweight_attributes p
    end
  end
end
