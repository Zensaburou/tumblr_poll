require 'mathn'
require_relative 'application'

class SimpsonService
  def calculate_all_indices
    Blog.all.each { |b| b.update(simpson_index: index_for(b)) }
  end

  def index_for(blog)
    # D_x
    sum = 0
    uniq_sources = blog.unique_sources
    uniq_sources.each { |source| sum += sub_index_for(blog, source) }
    sum
  end

  def sub_index_for(blog, source_title)
    # x_i(x_i -1) / X(X-1)
    source_count = blog.source_count(source_title)
    reblogged_post_count = blog.reblogged_post_count
    numerator = source_count * (source_count - 1)
    denominator = reblogged_post_count * (reblogged_post_count - 1)
    numerator / denominator
  end
end
