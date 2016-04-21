require 'mathn'
require_relative 'application'

class SimpsonService
  def calculate_all_indices
    Blog.all.each { |b| calculate_and_save_index(b) }
  end

  def calculate_and_save_index(blog)
    blog.update(simpson_index: index_for(blog))
  end

  def index_for(blog)
    # D_x / X(X-1)
    reblogged_post_count = blog.reblogged_post_count
    return 1 if [1, 0].include?(reblogged_post_count)

    denominator = reblogged_post_count * (reblogged_post_count - 1)
    numerator(blog) / denominator
  end

  def sub_index_for(blog, source_title)
    # x_i(x_i -1)
    source_count = blog.source_count(source_title)
    source_count * (source_count - 1)
  end

  private

  def numerator(blog)
    uniq_sources = blog.unique_sources
    sub_indices = uniq_sources.map { |s| sub_index_for(blog, s) }
    sub_indices.inject(:+)
  end
end
