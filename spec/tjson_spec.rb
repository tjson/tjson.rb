# frozen_string_literal: true

RSpec.describe TJSON do
  it "has a version number" do
    expect(TJSON::VERSION).not_to be nil
  end

  describe ".parse" do
    context "draft-tjson-examples.txt" do
      ExampleLoader.new.examples.each do |example|
        if example.success?
          it "succeeds on #{example.name} example: #{example.description}" do
            expect { TJSON.parse(example.data) }.to_not raise_error
          end
        else
          it "raises exception on #{example.name}: #{example.description}" do
            expect { TJSON.parse(example.data) }.to raise_error
          end
        end
      end
    end

    context "encoding" do
      let(:invalid_string) { "invalid\255".dup.force_encoding(Encoding::BINARY) }

      it "raises TJSON::EncodingError if given a invalid UTF-8 string" do
        expect { TJSON.parse(invalid_string) }.to raise_error(TJSON::EncodingError)
      end
    end

    context "parse errors" do
      let(:invalid_json) { "surely this is not valid JSON, wouldn't you say?" }

      it "raises TJSON::ParseError if the document is invalid" do
        expect { TJSON.parse(invalid_json) }.to raise_error(TJSON::ParseError)
      end
    end
  end
end
