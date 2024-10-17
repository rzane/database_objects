require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: 'database_objects_test',
)

ActiveRecord::Schema.define do
  create_table :people, force: true do |t|
    t.string :name
  end
end

class Person < ActiveRecord::Base
end

class GaryView < ActiveRecord::Base
  extend DatabaseObjects::Schema
  extend DatabaseObjects::View

  declare_view do
    Person.where(name: 'Gary')
  end
end

class SeriesView < ActiveRecord::Base
  extend DatabaseObjects::Schema
  extend DatabaseObjects::View

  declare_view <<~SQL
    SELECT generate_series(1, 3) AS index
  SQL
end

class SeriesFunction < ActiveRecord::Base
  extend DatabaseObjects::Schema
  extend DatabaseObjects::Function

  declare_function :generate_series
end
