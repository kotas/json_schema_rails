require 'spec_helper'

RSpec.describe JsonSchemaRails::Loaders::Directory do
  let(:loader) { JsonSchemaRails::Loaders::Directory.new(TEST_SCHEMAS_DIR) }

  describe "#load_schema" do
    subject { loader.load_schema(schema_name) }

    context "with .yml file" do
      let(:schema_name) { "posts/create" }
      it { should be_a JsonSchema::Schema }
    end

    context "with .yaml file" do
      let(:schema_name) { "posts/update" }
      it { should be_a JsonSchema::Schema }
    end

    context "with .json file" do
      let(:schema_name) { "posts/search" }
      it { should be_a JsonSchema::Schema }
    end

    context "with nonexist file" do
      let(:schema_name) { "posts/unknown" }
      it { should be_nil }
    end

    context "when extname specified" do
      before { loader.extnames = ".json" }

      context "with specified extname file" do
        let(:schema_name) { "posts/search" }
        it { should be_a JsonSchema::Schema }
      end

      context "with not specified extname file" do
        let(:schema_name) { "posts/create" }
        it { should be_nil }
      end
    end
  end

  describe "#load_schema!" do
    subject { -> { loader.load_schema!(schema_name) } }

    context "with exist file" do
      let(:schema_name) { "posts/create" }
      it "returns schema" do
        expect(subject.call).to be_a JsonSchema::Schema
      end
    end

    context "with nonexist file" do
      let(:schema_name) { "posts/unknown" }
      it { should raise_error JsonSchemaRails::SchemaNotFound }
    end
  end
end
