require 'spec_helper'

RSpec.describe JsonSchemaRails::Loaders::HyperSchema do
  let(:loader) { JsonSchemaRails::Loaders::HyperSchema.new(TEST_HYPER_SCHEMA_FILE) }

  describe "#load_schema" do
    subject { loader.load_schema(schema_name) }

    context "with known static route" do
      let(:schema_name) { "POST/posts" }
      it { should be_a JsonSchema::Schema }
    end

    context "with known dynamic route" do
      let(:schema_name) { "PUT/posts/123" }
      it { should be_a JsonSchema::Schema }
    end

    context "with nonexist route" do
      let(:schema_name) { "GET/unknown" }
      it { should be_nil }
    end
  end

  describe "#load_schema!" do
    subject { -> { loader.load_schema!(schema_name) } }

    context "with exist schema" do
      let(:schema_name) { "POST/posts" }
      it "returns schema" do
        expect(subject.call).to be_a JsonSchema::Schema
      end
    end

    context "with nonexist schema" do
      let(:schema_name) { "POST/unknown" }
      it { should raise_error JsonSchemaRails::SchemaNotFound }
    end
  end
end
