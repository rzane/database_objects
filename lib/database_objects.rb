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
      if block
        default_scope { from(block.call, table_name) }
      else
        default_scope { from("(#{sql}) #{table_name}") }
      end
    end
  end

  module Function
    def declare_function(name)
      define_singleton_method :execute do |*args|
        from(Arel::Nodes::NamedFunction.new(name.to_s, args, table_name))
      end
    end
  end
end
