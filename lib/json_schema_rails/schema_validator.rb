module JsonSchemaRails
  class SchemaValidator
    DEFAULT_SCHEMA_URI = 'http://json-schema.org/draft-04/schema'

    attr_reader :meta_schemas

    def initialize
      @meta_schemas = MetaSchemas.new
      @loader = Loader.new
    end

    def use_core_schemas!(options = {})
      schemas_dir = File.expand_path('../../../schemas', __FILE__)
      if options[:loose]
        add_meta_schema_file Dir[File.join(schemas_dir, '*.json')].sort
      else
        add_meta_schema_file Dir[File.join(schemas_dir, 'strict', '*.json')].sort
      end
    end

    def validate(schema_file)
      content = @loader.render_schema_content(schema_file)

      meta_schema_uri = content["$schema"] || content[:"$schema"] || DEFAULT_SCHEMA_URI
      unless meta_schema_uri
        raise JsonSchemaRails::SchemaNotFound, "No $schema specified"
      end

      meta_schema = @meta_schemas.lookup!(meta_schema_uri)
      valid, errors = meta_schema.validate(content)
      raise ValidationError.from_errors(errors, meta_schema) unless valid
      true
    end

    protected

    def add_meta_schema_file(*meta_schema_files)
      meta_schema_files.flatten.each do |file|
        @meta_schemas << @loader.load_schema!(file)
      end
      self
    end

    class MetaSchemas
      include Enumerable

      def initialize
        @store = JsonSchema::DocumentStore.new
        @expander = JsonSchema::ReferenceExpander.new
      end

      def <<(schema)
        Array(schema).each do |file|
          schema.expand_references!(store: @store)
          @store.add_schema(schema)
        end
      end

      def [](schema_uri)
        @store.lookup_schema(schema_uri.sub(/#+$/, ''))
      end

      def lookup!(schema_uri)
        self[schema_uri] or
          raise JsonSchemaRails::SchemaNotFound, "Unknown $schema: #{schema_uri}"
      end

      def each
        @store.each { |k, v| yield v }
      end

      def size
        reduce(0) { |sum, n| sum + 1 }
      end
    end

    class Loader < Loaders::Base
      def initialize
        super(cache: false)
      end

      def load_schema!(schema_path)
        load_schema_file(schema_path)
      end

      def render_schema_content(schema_path)
        load_schema_content(schema_path)
      end
    end
  end
end
