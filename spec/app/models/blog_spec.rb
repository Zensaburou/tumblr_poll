require 'spec_helper'

RSpec.describe Blog do
  let(:blog) { Blog.create(url: 'spam') }

  describe :reblogged_post_count do
    it 'returns a count of posts with a source title' do
      Post.create(blog_id: blog.id, source_title: 'bar')
      Post.create(blog_id: blog.id, source_title: 'foo')
      Post.create(blog_id: blog.id, source_title: '')
      Post.create(blog_id: blog.id, source_title: nil)

      expect(blog.reblogged_post_count).to be 2
    end
  end

  describe :unique_source_count do
    it 'returns count of unique source titles' do
      Post.create(blog_id: blog.id, source_title: '')
      Post.create(blog_id: blog.id, source_title: nil)
      Post.create(blog_id: blog.id, source_title: 'foo')
      Post.create(blog_id: blog.id, source_title: 'foo')

      expect(blog.unique_source_count).to eq 1
    end
  end

  describe :source_count_for do
    it 'returns count of times a source appears in a blog' do
      Post.create(blog_id: blog.id, source_title: 'bar')
      Post.create(blog_id: blog.id, source_title: 'bar')
      Post.create(blog_id: blog.id, source_title: 'foo')

      expect(blog.source_count('bar')).to be 2
    end
  end
end
