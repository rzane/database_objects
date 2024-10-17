# frozen_string_literal: true

RSpec.describe DatabaseObjects do
  it "has a version number" do
    expect(DatabaseObjects::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
