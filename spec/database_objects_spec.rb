# frozen_string_literal: true

RSpec.describe DatabaseObjects do
  it "has a version number" do
    expect(DatabaseObjects::VERSION).not_to be nil
  end

  it 'loads a series' do
    series = Series.from('(SELECT generate_series(1, 3) AS index) series')

    expect(series.to_a).to contain_exactly(
      have_attributes(index: 1),
      have_attributes(index: 2),
      have_attributes(index: 3),
    )
  end
end
