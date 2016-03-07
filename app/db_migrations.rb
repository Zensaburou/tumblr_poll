require 'active_record'
require_relative 'application'

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include? 'posts'
    create_table :posts do |t|
      t.column :blog_id, :integer
      t.column :post_id, :integer, limit: 8
      t.column :post_url, :text
      t.column :source_title, :text
      t.column :note_count, :integer
      t.column :date, :text
      t.column :post_type, :text
      t.column :is_reblogged, :integer
      t.column :timestamp, :integer, limit: 8
    end
  end

  unless ActiveRecord::Base.connection.tables.include? 'blogs'
    create_table :blogs do |t|
      t.column :url, :text
    end
  end
end

