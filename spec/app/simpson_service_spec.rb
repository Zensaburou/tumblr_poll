require_relative '../spec_helper'

RSpec.describe SimpsonService do
  let(:subject) { SimpsonService.new }
  let(:blog) { Blog.create }

  describe :calculate_all_indices do
    it 'saves the index for each blog' do
      blog
      allow_any_instance_of(SimpsonService).to receive(:index_for) { (1 / 3) }
      SimpsonService.new.calculate_all_indices
      blog.reload
      expect(blog.simpson_index).to eq((1 / 3).to_f)
    end
  end

  describe :index_for do
    it 'sums the sub indices' do
      Post.create(blog_id: blog.id, source_title: 'bar')
      Post.create(blog_id: blog.id, source_title: 'bar')
      Post.create(blog_id: blog.id, source_title: 'bar')
      Post.create(blog_id: blog.id, source_title: 'foo')
      Post.create(blog_id: blog.id, source_title: 'foo')
      Post.create(blog_id: blog.id, source_title: nil)

      result = subject.index_for(blog)
      expect(result).to eq 2 / 5
    end
  end

  describe :sub_index_for do
    it 'calculates the index correctly' do
      Post.create(blog_id: blog.id, source_title: 'bar')
      Post.create(blog_id: blog.id, source_title: 'bar')
      Post.create(blog_id: blog.id, source_title: 'foo')
      Post.create(blog_id: blog.id, source_title: nil)

      result = subject.sub_index_for(blog, 'bar')
      expect(result).to eq 1 / 3
    end
  end
end
