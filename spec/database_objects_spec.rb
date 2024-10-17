# frozen_string_literal: true

RSpec.describe DatabaseObjects do
  around do |example|
    ActiveRecord::Base.transaction do
      example.run
    ensure
      raise ActiveRecord::Rollback
    end
  end

  it "has a version number" do
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
      Person.create!(name: 'Gary')
      Person.create!(name: 'Other')

      expect(GaryView.all).to contain_exactly(have_attributes(name: 'Gary'))
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
