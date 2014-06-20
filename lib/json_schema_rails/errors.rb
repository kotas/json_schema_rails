module JsonSchemaRails
  class Error < StandardError; end

  class SchemaNotFound < Error
    def initialize(message = nil)
      super(message || 'No such schema')
    end
  end

  class SchemaParseError < Error
    attr_reader :schema

    def initialize(message, schema = nil)
      super(message)
      @schema = schema
    end
  end

  class ValidationError < Error
    attr_reader :schema
    attr_reader :errors

    def initialize(message, schema, errors = nil)
      super(message)
      @schema = schema
      @errors = errors
    end

    def self.from_errors(schema_name, schema, errors)
      message = "Validation error for schema #{schema_name}"

      errors.each do |err|
        if err.is_a?(JsonSchema::ValidationError)
          message << "\n- #{err.pointer}: failed schema #{err.schema.pointer}: #{err.message}"
        else
          message << "\n- #{err.schema.pointer}: #{err.message}"
        end
      end

      new(message, schema, errors)
    end
  end
end
