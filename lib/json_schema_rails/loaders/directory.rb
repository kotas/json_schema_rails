module JsonSchemaRails
  module Loaders
    class Directory < Base
      attr_accessor :path, :extnames

      def initialize(path, options = {})
        @path     = path
        @extnames = options.delete(:extnames) { %w(.yml .yaml .json) }
        super(options)
      end

      def load_schema!(schema_path)
        with_cache(schema_path) do
          file_path = lookup_schema_file(schema_path) or raise SchemaNotFound
          load_schema_file(file_path)
        end
      end

      protected

      def lookup_schema_file(schema_path)
        # Protection from directory traversal attack
        raise ArgumentError, "Invalid schema path" unless schema_path =~ /\A[\/a-zA-Z0-9_-]+\z/

        base_path = File.join(@path, schema_path)
        Dir.glob("#{base_path}#{extnames_glob}", File::FNM_NOESCAPE).first
      end

      def extnames_glob
        if @extnames.respond_to?(:join)
          glob = @extnames.join(',')
          @extnames.size > 1 ? "{#{glob}}" : glob
        else
          @extnames.to_s
        end
      end
    end
  end
end
