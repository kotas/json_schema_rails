require 'spec_helper'

RSpec.describe JsonSchemaRails::SchemaValidator do
  let(:validator) { JsonSchemaRails::SchemaValidator.new }

  describe "#use_core_schemas!" do
    context "with default option" do
      before { validator.use_core_schemas! }

      it "has 2 schemas" do
        expect(validator.meta_schemas.size).to eq 2
      end

      it "uses strict schemas" do
        schema = validator.meta_schemas.first
        expect(schema.additional_properties).to eq false
      end
    end

    context "with loose option" do
      before { validator.use_core_schemas!(loose: true) }

      it "has 2 schemas" do
        expect(validator.meta_schemas.size).to eq 2
      end

      it "uses loose schemas" do
        schema = validator.meta_schemas.first
        expect(schema.additional_properties).to eq true
      end
    end
  end

  describe "#validate" do
    before { validator.use_core_schemas! }
    subject { -> { validator.validate(schema_file) } }

    context "with valid schema" do
      let(:schema_file) { File.join(TEST_SCHEMAS_DIR, "posts/create.yml") }

      it "returns true" do
        expect(subject.call).to eq true
      end
    end

    context "with invalid schema" do
      let(:schema_file) { File.join(TEST_SCHEMAS_DIR, "invalid_schema.yml") }

      it "raises ValidationError with 2 errors" do
        expect(subject).to raise_error do |e|
          expect(e).to be_a JsonSchemaRails::ValidationError
          expect(e.errors.size).to eq 2
        end
      end
    end
  end
end
