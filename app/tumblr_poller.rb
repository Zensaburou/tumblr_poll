require 'application'
require 'tumblr_client'
require 'dotenv'
Dotenv.load

class TumblrPoller
  def initialize
    Tumblr.configure do |config|
      config.consumer_key = ENV['CONSUMER_KEY']
      config.consumer_secret = ENV['CONSUMER_SECRET']
      config.oauth_token = ENV['OAUTH_TOKEN']
      config.oauth_token_secret = ENV['OAUTH_TOKEN_SECRET']
    end
    @client = Tumblr::Client.new
  end

  def poll_blogs(blogs, newest_timestamp, oldest_timestamp)
    blogs.each { |blog| parse_posts(blog, newest_timestamp, oldest_timestamp) }
  end

  def parse_posts(blog, newest_timestamp, oldest_timestamp)
    posts(blog).each do |post|
      next if post_too_recent?(post)
      break if post_too_old?(post)
      save_post(post)
    end
  end

  def posts(blog)
    @client.posts(blog, limit: 20)['posts']
  end

  def post_too_recent?(post)
    post['timestamp'] > newest_timestamp
  end

  def post_too_old?(post)
    post['timestamp'] < oldest_timestamp
  end

  def save_post(post)
    Post.create(post_attrs(post))
  end

  def post_attrs(post_json)
    {
      post_id: post_json['id'],
      post_url: post_json['post_url'],
      note_count: post_json['note_count'],
      date: post_json['date'],
      post_type: post_json['type'],
      timestamp: post_json['timestamp'],
      source_title: post_json['source_title'],
      is_reblogged: is_reblogged?(post_json)
    }
  end

  def is_reblogged?(post_json)
    post_json['source_title'].to_s.empty? ? 0 : 1
  end
end
