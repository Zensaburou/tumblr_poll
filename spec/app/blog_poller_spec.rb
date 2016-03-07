require_relative '../spec_helper'
require 'json'

RSpec.describe BlogPoller do
  let(:fixture_file) { File.join(File.dirname(__FILE__), '../fixtures/tumblr_posts.json') }
  let(:posts_json) { File.read(fixture_file) }
  let(:posts_hash) { JSON.parse(posts_json)['posts'] }
  let(:blog) { Blog.create(url: 'foobarbaz.tumblr.com') }

  let(:subject) { BlogPoller.new(blog) }

  describe :poll_posts do
    it 'saves posts within the time range' do
      blogpoller = BlogPoller.new(blog, 1457302322, 1457302320)
      allow(blogpoller).to receive(:post_list) { posts_hash }
      expect{blogpoller.poll_posts}.to change(Post.all, :count).by 1
    end
  end

  describe :parse_post_list do
    it 'skips posts that are too recent' do
      blogpoller = BlogPoller.new(blog, 2, 1)
      expect{blogpoller.parse_post_list(posts_hash)}.to change(Post.all, :count).by 0
    end

    it 'returns complete once an old enough post is found' do
      blogpoller = BlogPoller.new(blog, 1457302322, 1457300594)
      expect(blogpoller.parse_post_list(posts_hash)).to eq 'complete'
    end
  end

  describe :save_post do
    it 'creates a post' do
      subject.save_post(posts_hash.first)
      post = Post.last

      expect(post.post_id).to eq 140590519517
      expect(post.post_url).to eq 'http://foobarbaz.tumblr.com/post/140590519517/this-is-my-shit'
      expect(post.note_count).to eq 34708
      expect(post.date).to eq "2016-03-06 22:12:01 GMT"
      expect(post.post_type).to eq 'photo'
      expect(post.timestamp).to eq 1457302321
      expect(post.source_title).to eq 'spambarbaz'
      expect(post.is_reblogged).to eq 1
      expect(post.blog_id).to eq blog.id
    end
  end

  describe :post_attrs do
    it 'returns the correct hash' do
      expected_hash = {
        post_id: 140590519517,
        post_url: "http://foobarbaz.tumblr.com/post/140590519517/this-is-my-shit",
        note_count: 34708,
        date: "2016-03-06 22:12:01 GMT",
        post_type: 'photo',
        timestamp: 1457302321,
        source_title: 'spambarbaz',
        is_reblogged: 1,
        blog_id: blog.id
      }
      expect(subject.post_attrs(posts_hash.first)).to eq expected_hash
    end
  end
end
