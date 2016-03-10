require_relative '../application'

class Blog < ActiveRecord::Base
  attr_reader :simpson_index

  has_many :posts

  def reblogged_post_count
    # X
    reblogged_posts.count
  end

  def reblogged_posts
    posts.where.not(source_title: nil).where.not(source_title: '')
  end

  def unique_sources
    reblogged_posts.pluck(:source_title).uniq
  end

  def unique_source_count
    # S
    unique_sources.count
  end

  def source_count(source_title)
    # x_i, y_i
    posts.where(source_title: source_title).count
  end

  def simpson_index
    simpson_index ||= SimpsonService.new.index_for(self)
  end
end
