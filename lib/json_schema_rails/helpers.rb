module JsonSchemaRails
  module Helpers
    extend ActiveSupport::Concern

    included do
      rescue_from JsonSchemaRails::ValidationError, with: :schema_validation_failed
    end

    module ClassMethods
      def validate_schema(options = {})
        before_filter :validate_schema!, options
      end
    end

    def validate_schema(schema_name = nil)
      validate_schema!(schema_name)
    rescue JsonSchemaRails::ValidationError
      false
    end

    def validate_schema!(schema_name = nil)
      schema_name ||= [
        "#{controller_path}/#{action_name}",
        "#{request.method}#{request.path}"
      ]
      ::JsonSchemaRails.validate!(schema_name, params)
      true
    end

    def schema_validation_failed(exception = nil)
      if exception
        raise exception if Rails.env.development?
        logger.debug exception.message
      end
      render nothing: true, status: 400
    end
  end
end
