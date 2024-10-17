require "active_support/concern"

module DatabaseObjects
  module Schema
    def load_schema!
      @columns_hash = {}.freeze
    end

    def declare_view(sql = nil, &block)
      if block
        default_scope { from(block.call, table_name) }
      else
        default_scope { from("(#{sql}) AS #{connection.quote_table_name(table_name)}") }
      end
    end
  end
end
