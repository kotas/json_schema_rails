require "erb"
require "json"
require "yaml"
require "json_schema"

module JsonSchemaRails
  module Loaders
    class Base
      attr_writer :cache

      def initialize(options = {})
        @cache = options.fetch(:cache) { true }
      end

      def cache?
        !!@cache
      end

      def clear
        cache_data.clear
      end

      def load_schema(schema_path)
        load_schema!(schema_path)
      rescue SchemaNotFound
        nil
      end

      def load_schema!(schema_path)
        raise NotImplementedError
      end

      protected

      def with_cache(name)
        if cache?
          cache_data.fetch(name) { cache_data[name] = yield }
        else
          yield
        end
      end

      def cache_data
        @cache_data ||= {}
      end

      def load_schema_file(file_path)
        JsonSchema.parse!(load_schema_content(file_path))
      rescue JsonSchema::SchemaError => e
        raise SchemaParseError.new(e.mssage, e.schema)
      end

      def load_schema_content(file_path)
        contents = ERB.new(IO.read(file_path)).result
        case File.extname(file_path)
        when '.json'
          JSON.load(contents)
        when '.yaml', '.yml'
          YAML.load(contents)
        else
          raise ArgumentError, "Unknown schema file type"
        end
      rescue Errno::ENOENT
        raise SchemaNotFound
      rescue JSON::ParserError => e
        raise SchemaParseError, "Failed to parse schema: #{e.message}"
      rescue YAML::SyntaxError => e
        raise SchemaParseError, "Failed to parse schema: #{e.message}"
      end
    end
  end
end
