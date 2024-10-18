require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: 'database_objects_test',
)

ActiveRecord::Schema.define do
  create_table :people, force: true do |t|
    t.string :name
  end

  create_table :posts, force: true do |t|
    t.string :content
    t.belongs_to :person
    t.datetime :created_at, precision: 6
  end
end

class Person < ActiveRecord::Base
  has_many :posts
  has_one :most_recent_post
end

class Post < ActiveRecord::Base
  belongs_to :person
end

class MostRecentPost < ActiveRecord::Base
  extend DatabaseObjects::Schema
  extend DatabaseObjects::View

  belongs_to :person

  view do
    Post.order(:person_id, created_at: :desc).select('DISTINCT ON (person_id) posts.*')
  end
end

class SeriesView < ActiveRecord::Base
  extend DatabaseObjects::Schema
  extend DatabaseObjects::View

  view <<~SQL
    SELECT generate_series(1, 3) AS index
  SQL
end

class SeriesFunction < ActiveRecord::Base
  extend DatabaseObjects::Schema
  extend DatabaseObjects::Function

  function :generate_series
end
