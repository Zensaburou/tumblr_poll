require 'mathn'
require_relative 'application'

class OverlapService
  def calculate_all_overlaps
    blog_pairs = Blog.all.pluck(:id).to_a.combination(2).to_a
    blog_pairs.each do |blog_id_array|
      first_blog_id = blog_id_array[0]
      second_blog_id = blog_id_array[1]
      overlap = calculate_overlap(Blog.find(first_blog_id), Blog.find(second_blog_id))

      Comparison.create(
        first_blog_id: first_blog_id,
        second_blog_id: second_blog_id,
        overlap: overlap
      )
    end
  end

  def calculate_overlap(first_blog_id, second_blog_id)
    first_blog = Blog.find(first_blog_id)
    second_blog = Blog.find(second_blog_id)
    numerator(first_blog, second_blog) / denominator(first_blog, second_blog)
  end

  def numerator(first_blog, second_blog)
    2 * series(first_blog, second_blog)
  end

  def denominator(first_blog, second_blog)
    simpson_sum = (first_blog.get_simpson_index + second_blog.get_simpson_index)
    total_post_product = first_blog.reblogged_post_count * second_blog.reblogged_post_count
    simpson_sum * total_post_product
  end

  def series(first_blog, second_blog)
    sum = 0
    uniq_sources = first_blog.unique_sources
    uniq_sources.each { |source| sum += source_count_product(first_blog, second_blog, source) }
    sum
  end

  def source_count_product(first_blog, second_blog, source)
    # x_i * y_i
    first_blog.source_count(source) * second_blog.source_count(source)
  end
end
