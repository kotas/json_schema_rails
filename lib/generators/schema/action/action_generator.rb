module Schema
  module Generators
    class ActionGenerator < Rails::Generators::NamedBase
      argument :parameters, type: :array, default: [], banner: "param[:type][:required] param[:type][:required]"
      source_root File.expand_path("../templates", __FILE__)

      def initialize(args, *options)
        super
        parse_parameters!
      end

      def create_schema_file
        template "schema.yml.erb", File.join("app/schemas", class_path, "#{file_name}.yml")
      end

      protected

      def schema_title
        "#{human_name} #{class_path.map(&:singularize).join(' ').titleize}"
      end

      def parse_parameters!
        self.parameters = parameters.map do |param|
          name, *options = param.split(':')
          options = options.map(&:to_sym) if options
          Parameter.new(name, options)
        end
      end

      def required_parameters
        parameters.select(&:required?)
      end

      class Parameter
        attr_reader :name, :type
        alias_method :to_s, :name

        def initialize(name, options)
          @name = name

          options ||= []
          @required = !!options.delete(:required)
          @type     = options.shift || :string
        end

        def required?
          @required
        end
      end
    end
  end
end
