require 'benchmark'
require_relative '../app/application'

class Benchmarker
  def initialize
    @newest_time = Time.now.to_i
    @oldest_time = (Time.now - 10000000).to_i
    @blog_array = [
      Blog.create!(url: 'congressarchives.tumblr.com'),
      Blog.create!(url: 'whitehouse.tumblr.com'),
      Blog.create!(url: 'statedept.tumblr.com'),
      Blog.create!(url: 'nasa.tumblr.com'),
      Blog.create!(url: 'spaceforeurope.tumblr.com')
    ]
  end

  def poll_blogs
    @blog_array.each { |b| BlogPoller.new(b, @newest_time, @oldest_time).poll_posts }
  end

  def make_tumblr_api_request(blog)
    poller = BlogPoller.new(@blog_array.first, @newest_time, @oldest_time)
    @posts = poller.post_list
  end

  def save_posts_to_db(posts)
    poller = BlogPoller.new(@blog_array.first, @newest_time, @oldest_time)
    poller.parse_post_list(posts)
  end

  def calculate_simpson_indices
    @blog_array.each { |b| SimpsonService.new.calculate_and_save_index(b) }
  end

  def run_benchmarks
    @blog_array.each { |b| b.posts.destroy_all }

    Benchmark.bm do |bm|
      puts 'API call benchmark'
      bm.report { make_tumblr_api_request(@blog_array.first) }

      puts 'Post parse and save benchmark'
      bm.report { save_posts_to_db(@posts) }

      @blog_array.each  { |b| b.posts.destroy_all }
      @blog_array.each  { |b| b.update!(completed: false) }

      puts 'Integration benchmark'
      bm.report { poll_blogs }

      puts 'Simpson benchmark'
      bm.report { calculate_simpson_indices }

      puts 'Morishita benchmark'
      bm.report { OverlapService.new.calculate_all_overlaps }
    end
  end
end
