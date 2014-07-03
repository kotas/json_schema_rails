class HelpersController < ApplicationController
  def show_schema_path
    path = json_schema_rails.schema_path(params[:schema_name])
    render text: path
  end

  def show_schema_url
    url = json_schema_rails.schema_url(params[:schema_name])
    render text: url
  end
end
