# frozen_string_literal: true

RSpec.describe TJSON::Binary do
  describe ".from_base16" do
    let(:example_base16) { "48656c6c6f2c20776f726c6421".dup }
    let(:example_result) { "Hello, world!".dup }

    it "parses hexadecimal" do
      expect(described_class.from_base16(example_base16)).to eq example_result
    end
  end
end
