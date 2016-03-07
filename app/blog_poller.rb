require_relative 'application'

class BlogPoller
  def initialize(blog)
    @blog = blog
  end

  def parse_posts(newest_timestamp, oldest_timestamp)
    posts(@blog).each do |post|
      next if post_too_recent?(post)
      break if post_too_old?(post)
      save_post(post)
    end
  end

  def posts(offset=0)
    TumblrClient.new.client.posts(@blog.url, limit: 20, offset: offset)['posts']
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
      is_reblogged: reblogged?(post_json),
      blog_id: @blog.id
    }
  end

  def reblogged?(post_json)
    post_json['source_title'].to_s.empty? ? 0 : 1
  end
end
