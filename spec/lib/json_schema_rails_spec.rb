require 'spec_helper'

RSpec.describe JsonSchemaRails do
  before do
    JsonSchemaRails.schema_loader = JsonSchemaRails::Loaders::Directory.new(TEST_SCHEMAS_DIR)
  end

  describe "#validate!" do
    subject { -> { JsonSchemaRails.validate! schema_name, data } }

    context "with valid data" do
      let(:schema_name) { "posts/create" }
      let(:data) { { "post" => { "title" => "Hello, world!", "body" => "Test Body" } } }
      it { should_not raise_error }
    end

    context "with invalid data" do
      let(:schema_name) { "posts/create" }
      let(:data) { { "post" => { "title" => "Hello, world!" } } }
      it { should raise_error JsonSchemaRails::ValidationError }
    end

    context "with unknown schema" do
      let(:schema_name) { "posts/unknown" }
      let(:data) { {} }
      it { should raise_error JsonSchemaRails::SchemaNotFound }
    end

    context "with syntax errors in schema" do
      let(:schema_name) { "syntax_error" }
      let(:data) { {} }
      it { should raise_error JsonSchemaRails::SchemaParseError }
    end
  end

  describe "#validate" do
    subject { -> { JsonSchemaRails.validate schema_name, data } }

    context "with valid data" do
      let(:schema_name) { "posts/create" }
      let(:data) { { "post" => { "title" => "Hello, world!", "body" => "Test Body" } } }

      it "returns a tuple of true validation result and empty errors" do
        result, errors = subject.call
        expect(result).to eq true
        expect(errors).to be_empty
      end
    end

    context "with invalid data" do
      let(:schema_name) { "posts/create" }
      let(:data) { { "post" => { "title" => "Hello, world!" } } }

      it "returns a tuple of false validation result and errors" do
        result, errors = subject.call
        expect(result).to eq false
        expect(errors).not_to be_empty
      end
    end

    context "with unknown schema" do
      let(:schema_name) { "posts/unknown" }
      let(:data) { {} }
      it { should raise_error JsonSchemaRails::SchemaNotFound }
    end

    context "with syntax errors in schema" do
      let(:schema_name) { "syntax_error" }
      let(:data) { {} }
      it { should raise_error JsonSchemaRails::SchemaParseError }
    end
  end

  describe "#lookup_schema!" do
    subject { -> { JsonSchemaRails.lookup_schema!(schema_name) } }

    context "with known schema" do
      let(:schema_name) { "posts/create" }

      it "returns the schema" do
        expect(subject.call).to be_a JsonSchema::Schema
      end
    end

    context "with unknown schema" do
      let(:schema_name) { "posts/unknown" }
      it { should raise_error JsonSchemaRails::SchemaNotFound }
    end

    context "with multiple schema names" do
      let(:schema_name) { ["posts/unknown", "posts/create"] }

      it "returns the first found one" do
        expect(subject.call).to be_a JsonSchema::Schema
      end
    end
  end

  describe "#lookup_schema" do
    subject { JsonSchemaRails.lookup_schema(schema_name) }

    context "with known schema" do
      let(:schema_name) { "posts/create" }

      it "returns the schema" do
        should be_a JsonSchema::Schema
      end
    end

    context "with unknown schema" do
      let(:schema_name) { "posts/unknown" }
      it { should be_nil }
    end

    context "with multiple schema names" do
      let(:schema_name) { ["posts/unknown", "posts/create"] }

      it "returns the first found one" do
        should be_a JsonSchema::Schema
      end
    end
  end
end
