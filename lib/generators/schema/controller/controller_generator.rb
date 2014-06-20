module Schema
  module Generators
    class ControllerGenerator < Rails::Generators::NamedBase
      argument :actions, type: :array, banner: "action action"
      source_root File.expand_path("../templates", __FILE__)

      def create_schema_files
        actions.each do |act|
          self.action_name = act.to_s.underscore
          template "schema.yml.erb", File.join("app/schemas", class_path, file_name, "#{action_name}.yml")
        end
      end

      protected

      attr_accessor :action_name

      def model_name
        file_name.singularize
      end

      def schema_title
        "#{action_name.to_s.humanize} #{model_name.titleize}"
      end
    end
  end
end
