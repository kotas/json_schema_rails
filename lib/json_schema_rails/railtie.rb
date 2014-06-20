require "json_schema_rails/helpers"

module JsonSchemaRails
  class Railtie < ::Rails::Railtie
    initializer "json_schema_rails.set_schema_loader" do |app|
      if schema_file = Dir[app.root.join('app', 'schema.*')].first
        loader = JsonSchemaRails::Loaders::HyperSchema.new(schema_file)
      else
        loader = JsonSchemaRails::Loaders::Directory.new(app.root.join('app', 'schemas').to_path)
      end
      loader.cache = false if Rails.env.development?
      JsonSchemaRails.schema_loader = loader
    end

    initializer "json_schema_rails.include_helpers" do
      ActiveSupport.on_load :action_controller do
        include ::JsonSchemaRails::Helpers
      end
    end

    rake_tasks do
      load File.expand_path("../../tasks/schema_tasks.rake", __FILE__)
    end
  end
end
