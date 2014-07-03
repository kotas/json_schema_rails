require 'spec_helper'

RSpec.describe HelpersController, type: :controller do
  describe "schema_path helper" do
    it "returns a path to schema endpoint" do
      get "show_schema_path", { "schema_name" => "posts/create" }
      expect(response.body).to eq "/schemas/posts/create"
    end
  end

  describe "schema_url helper" do
    it "returns a URL to schema endpoint" do
      get "show_schema_url", { "schema_name" => "posts/create" }
      expect(response.body).to eq "#{request.base_url}/schemas/posts/create"
    end
  end
end
