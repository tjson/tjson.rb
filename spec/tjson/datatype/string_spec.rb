# frozen_string_literal: true

RSpec.describe TJSON::DataType::String do
  context "valid UTF-8 string" do
    let(:example_string) { "Hello, world!".encode(Encoding::UTF_8) }

    it "parses successfully" do
      expect(subject.convert(example_string)).to eq example_string
    end
  end

  context "non-UTF-8 string" do
    let(:invalid_string) { "Not UTF-8!".dup.force_encoding(Encoding::BINARY) }

    it "raises TJSON::EncodingError" do
      expect { subject.convert(invalid_string) }.to raise_error(TJSON::EncodingError)
    end
  end
end
