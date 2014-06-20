require "json_schema_rails/version"
require "json_schema_rails/errors"
require "json_schema_rails/loaders"
require "json_schema_rails/railtie" if defined?(Rails)

module JsonSchemaRails
  def self.schema_loader
    @schema_loader ||= Loaders::Directory.new('app/schemas')
  end

  def self.schema_loader=(loader)
    @schema_loader = loader
  end

  def self.validate(schema_name, data)
    schema = lookup_schema!(schema_name)
    schema.validate(data)
  end

  def self.validate!(schema_name, data)
    schema = lookup_schema!(schema_name)
    valid, errors = schema.validate(data)
    unless valid
      raise ValidationError.from_errors(schema_name, schema, errors)
    end
    true
  end

  def self.lookup_schema(schema_name)
    lookup_schema!(schema_name)
  rescue SchemaNotFound
    nil
  end

  def self.lookup_schema!(schema_name)
    Array(schema_name).each do |name|
      schema = schema_loader.load_schema(name)
      return schema if schema
    end
    raise SchemaNotFound
  end
end
