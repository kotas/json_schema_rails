# Patch for JsonSchema::Parser to memorize schema data

require "json_schema/parser"

module JsonSchema
  class Parser
    alias_method :_super_parse_data, :parse_data

    def parse_data(data, parent, fragment)
      schema = _super_parse_data(data, parent, fragment)
      schema.data = data
      schema
    end
  end
end
