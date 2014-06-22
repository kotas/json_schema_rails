require 'spec_helper'
require 'yaml'

RSpec.describe JsonSchema::Parser do
  describe "#parse!" do
    let(:schema_content) { YAML.load_file(File.join(TEST_SCHEMAS_DIR, 'posts/create.yml')) }
    subject(:schema)     { JsonSchema.parse!(schema_content) }

    it "sets original schema data to schema#data" do
      expect(schema.data).to eq schema_content
    end
  end
end
