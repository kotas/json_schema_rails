module JsonSchemaRails
  module Loaders
    class HyperSchema < Base
      attr_accessor :path

      def initialize(path, options = {})
        @path = path
        super(options)
      end

      def load_schema!(schema_path)
        with_cache(schema_path) do
          schema_index.find(schema_path) or raise SchemaNotFound
        end
      end

      protected

      def schema_index
        with_cache(:_schema_index) do
          schema = load_schema_file(@path).tap(&:expand_references!)
          SchemaIndex.new(schema)
        end
      end

      class SchemaIndex
        def initialize(schema)
          @index = { _schema: schema }
          build(schema)
        end

        def build(schema)
          schema.links.each do |link|
            if link.href
              keys = index_keys("#{link.method || 'GET'}/#{link.href}", true)
              tail = keys.reduce(@index) { |hash, key| hash[key] ||= {} }
              tail[:_schema] = schema
            end
          end
          schema.properties.each do |key, subschema|
            build(subschema)
          end
        end

        def find(schema_path)
          keys = index_keys(schema_path, false)
          tail = keys.reduce(@index) do |hash, key|
            if hash.key?(key)
              hash[key]
            else
              next_key = hash.keys.find { |k| k === key } or break
              hash[next_key]
            end
          end
          tail[:_schema] if tail
        end

        private

        def index_keys(path, for_build)
          keys = path.to_s.downcase.split('/').reject(&:empty?)
          keys.map! { |k| k.gsub!(/\{(.*?)\}/, '[^/]+') ? %r/^#{k}$/ : k } if for_build
          keys
        end
      end
    end
  end
end
