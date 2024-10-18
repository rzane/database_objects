# frozen_string_literal: true

require_relative "database_objects/version"

module DatabaseObjects
  class Error < StandardError; end

  module Schema
    def load_schema!
      @columns_hash = {}.freeze
    end
  end

  module View
    def declare_view(sql = nil, &block)
      block ||= -> { Arel.sql(sql) }

      define_singleton_method :cte do
        { table_name => block.call }
      end

      default_scope { with(cte) }
    end
  end

  module Function
    def declare_function(name)
      define_singleton_method :cte do |*args|
        function = Arel::Nodes::NamedFunction.new(name.to_s, args)
        { table_name => select(Arel.star).from(function) }
      end

      scope :execute, ->(*args) { with(cte(*args)) }
    end
  end
end
