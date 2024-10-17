require "active_support/concern"

module DatabaseObjects
  module Schema
    extend ActiveSupport::Concern

    module ClassMethods
      def load_schema!
        @columns_hash = {}.freeze
      end
    end
  end
end
