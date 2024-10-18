# frozen_string_literal: true

RSpec.describe DatabaseObjects do
  around do |example|
    ActiveRecord::Base.transaction do
      example.run
    ensure
      raise ActiveRecord::Rollback
    end
  end

  it 'has a version number' do
    expect(DatabaseObjects::VERSION).not_to be nil
  end

  describe 'declare_view' do
    it 'acts like a view with SQL' do
      expect(SeriesView.all).to contain_exactly(
        have_attributes(index: 1),
        have_attributes(index: 2),
        have_attributes(index: 3),
      )
    end

    it 'acts like a view with ActiveRecord' do
      person = Person.create!(name: 'Gary')
      post = Post.create!(person:, content: 'Latest', created_at: 1.week.ago)
      Post.create!(person:, content: 'Oldest', created_at: 2.weeks.ago)

      expect(MostRecentPost.all).to contain_exactly(have_attributes(person:, id: post.id))
    end

    it 'supports associations' do
      person = Person.create!(name: 'Gary')
      post = Post.create!(person:, content: 'Latest', created_at: 1.week.ago)

      expect(person.most_recent_post.id).to eq(post.id)
    end
  end

  describe 'declare_function' do
    it 'can be executed' do
      expect(SeriesFunction.execute(1, 3)).to contain_exactly(
        have_attributes(series_functions: 1),
        have_attributes(series_functions: 2),
        have_attributes(series_functions: 3)
      )
    end
  end
end
