# frozen_string_literal: true

RSpec.describe DatabaseObjects do
  it "has a version number" do
    expect(DatabaseObjects::VERSION).not_to be nil
  end

  describe 'declare_view with SQL' do
    let(:model) do
      define_model do
        declare_view 'SELECT generate_series(1, 1) AS index'
      end
    end

    it 'acts like a view' do
      expect(model.all).to contain_exactly(have_attributes(index: 1))
    end
  end

  describe 'declare_view with ActiveRecord' do
    let(:model) do
      define_model do
        declare_view { Person.where(name: 'Gary') }
      end
    end

    it 'acts like a view' do
      Person.create!(name: 'Gary')
      Person.create!(name: 'Other')

      expect(model.all).to contain_exactly(have_attributes(name: 'Gary'))
    end
  end

  describe 'declare_function' do
    let(:model) do
      define_model do
        declare_function :generate_series
      end
    end

    it 'can be executed' do
      expect(model.execute(1, 3)).to contain_exactly(
        have_attributes(examples: 1),
        have_attributes(examples: 2),
        have_attributes(examples: 3)
      )
    end
  end

  def define_model(&)
    model = Class.new(ActiveRecord::Base) do
      extend DatabaseObjects::Schema
      extend DatabaseObjects::View
      extend DatabaseObjects::Function

      self.table_name = 'examples'
    end

    model.class_eval(&)
    model
  end
end
