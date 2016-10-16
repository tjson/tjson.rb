# frozen_string_literal: true

RSpec.describe TJSON::TagParser do
  describe ".parse" do
    context "UTF-8 strings" do
      let(:example_result) { "hello, world!".dup }
      let(:example_string) { "u:#{example_result}".dup }

      it "parses" do
        expect(described_class.parse(example_string)).to eq example_result
      end
    end

    context "untagged strings" do
      let(:example_string) { "hello, world!" }

      it "raises TJSON::ParseError" do
        expect { described_class.parse(example_string) }.to raise_error(TJSON::ParseError)
      end
    end
  end

  describe ".from_base16" do
    let(:example_base16) { "48656c6c6f2c20776f726c6421".dup }
    let(:example_result) { "Hello, world!".dup }

    it "parses hexadecimal" do
      result = described_class.from_base16(example_base16)
      expect(result).to eq example_result
      expect(result.encoding).to eq Encoding::BINARY
    end
  end
end
