module JsonSchemaRails
  class SchemasController < ApplicationController
    def get
      schema = JsonSchemaRails.lookup_schema(params[:schema])
      raise ActionController::RoutingError.new('No Such Schema') unless schema

      respond_to do |format|
        format.yaml { render text: schema.to_hash.to_yaml, content_type: 'text/yaml' }
        format.json { render json: schema }
      end
    end
  end
end
