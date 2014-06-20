class PostsController < ApplicationController
  validate_schema

  def create
    render text: "Created #{params[:post][:title]}"
  end

  def update
    render text: "Updated #{params[:post][:title]}"
  end
end
