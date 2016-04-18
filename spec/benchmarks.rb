require 'benchmark'
require_relative '../app/application'

class Benchmarker
  def initialize
    @newest_time = Time.now.to_i
    @oldest_time = (Time.now - 1000).to_i
    @first_blog = Blog.create!(url: 'congressarchives.tumblr.com')
    @second_blog = Blog.create!(url: 'whitehouse.tumblr.com')
  end

  def poll_blogs(blog_array)
    blog_array.each { |b| BlogPoller.new(b, @newest_time, @oldest_time).poll_posts }
  end

  def make_tumblr_api_request(blog)
    poller = BlogPoller.new(@first_blog, @newest_time, @oldest_time)
    @posts = poller.post_list
  end

  def save_posts_to_db(posts)
    poller = BlogPoller.new(@first_blog, @newest_time, @oldest_time)
    poller.parse_post_list(posts)
  end

  def run_benchmarks
    @first_blog.posts.destroy_all
    @second_blog.posts.destroy_all

    Benchmark.bm do |bm|
      puts 'API call benchmark'
      bm.report { make_tumblr_api_request(@first_blog) }

      puts 'Post parse and save benchmark'
      bm.report { save_posts_to_db(@posts) }

      @first_blog.posts.destroy_all
      @second_blog.posts.destroy_all

      puts 'Integration benchmark'
      bm.report { poll_blogs([@first_blog, @second_blog]) }

      puts 'Simpson benchmark'
      bm.report { SimpsonService.new.calculate_and_save_index(@first_blog) }

      puts 'Morishita benchmark'
      bm.report { OverlapService.new.calculate_overlap(@first_blog.id, @second_blog.id) }
    end
  end
end
