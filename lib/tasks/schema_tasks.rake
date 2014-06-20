require "pathname"
require "json_schema_rails/schema_validator"

namespace :schema do
  desc "Check syntax of schema files"
  task :check do
    validator = JsonSchemaRails::SchemaValidator.new.use_core_schemas!

    find_root = defined?(Rails) ? Rails.root : Pathname.pwd
    schema_paths = Dir[
      find_root.join('app', 'schema.*'),
      find_root.join('app', 'schemas', '**', '*.{json,yml,yaml}')
    ]
    if schema_paths.empty?
      puts "No schema files found"
      next
    end

    error_count = 0
    schema_paths.each do |path|
      begin
        validator.validate(path)
      rescue JsonSchemaRails::Error => e
        relpath = Pathname.new(path).relative_path_from(find_root)
        puts "#{relpath}: #{e.message}"
        error_count += 1
      end
    end

    if error_count == 0
      STDERR.puts "All schema files has passed validation!"
    else
      STDERR.puts
      abort "#{error_count} file(s) have failed for validation"
    end
  end
end
