require 'spec_helper'

RSpec.describe JsonSchemaRails::SchemasController, type: :request do
  describe "GET #get" do
    context "with existing schema" do
      before { get "/schemas/posts/create#{format}" }
      let(:expected_schema) { YAML.load_file(Rails.root.join('app', 'schemas', 'posts', 'create.yml').to_s) }

      context "as json" do
        let(:format) { ".json" }
        it "returns the schema as json" do
          expect(response).to be_success
          expect(response.content_type).to eq :json
          expect(response.body).to eq expected_schema.to_json
        end
      end

      context "without format" do
        let(:format) { "" }
        it "returns the schema as json" do
          expect(response).to be_success
          expect(response.content_type).to eq :json
          expect(response.body).to eq expected_schema.to_json
        end
      end

      context "as yaml" do
        let(:format) { ".yaml" }
        it "returns the schema as yaml" do
          expect(response).to be_success
          expect(response.content_type).to eq :yaml
          expect(response.body).to eq expected_schema.to_yaml
        end
      end
    end

    context "with nonexisting schema" do
      subject { -> { get "/schemas/posts/nonexist.json" } }

      it "raises ActionController::RoutingError" do
        expect(subject).to raise_error ActionController::RoutingError
      end
    end
  end
end
