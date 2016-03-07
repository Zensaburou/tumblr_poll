require_relative '../spec_helper'
require 'json'

RSpec.describe BlogPoller do
  let(:fixture_file) { File.join(File.dirname(__FILE__), '../fixtures/tumblr_post.json') }
  let(:post_json) { File.read(fixture_file) }
  let(:post_hash) { JSON.parse(post_json) }
  let(:blog) { Blog.create(blog_url: 'foobarbaz.tumblr.com') }

  let(:subject) { BlogPoller.new(blog) }

  describe :post_attrs do
    it 'returns the correct hash' do
      expected_hash = {
        post_id: 140590559767,
        post_url: 'http://foobarbaz.tumblr.com/post/140590559767/rosebeaches-i-want-love-thats-warm-and',
        note_count: 29906,
        date: '2016-03-06 22:12:46 GMT',
        post_type: 'text',
        timestamp: 1457302366,
        source_title: 'rosebeaches',
        is_reblogged: 1,
        blog_id: blog.id
      }
      expect(subject.post_attrs(post_hash)).to eq expected_hash
    end
  end

  describe :save_post do
    it 'creates a post' do
      subject.save_post(post_hash)
      post = Post.last

      expect(post.post_id).to eq 140590559767
      expect(post.post_url).to eq 'http://foobarbaz.tumblr.com/post/140590559767/rosebeaches-i-want-love-thats-warm-and'
      expect(post.note_count).to eq 29906
      expect(post.date).to eq '2016-03-06 22:12:46 GMT'
      expect(post.post_type).to eq 'text'
      expect(post.timestamp).to eq 1457302366
      expect(post.source_title).to eq 'rosebeaches'
      expect(post.is_reblogged).to eq 1
      expect(post.blog_id).to eq blog.id
    end
  end
end
