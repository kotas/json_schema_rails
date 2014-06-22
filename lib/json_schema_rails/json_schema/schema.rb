# Patch for JsonSchema::Schema to memorize schema data

require "json_schema/schema"

module JsonSchema
  class Schema
    attr_accessor :data

    def to_hash
      data
    end
  end
end
