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
