# frozen_string_literal: true

RSpec.describe TJSON::DataType::Binary do
  describe TJSON::DataType::Binary16 do
    subject(:binary16) { described_class.new }

    context "valid base16 string" do
      let(:example_base16) { "48656c6c6f2c20776f726c6421" }
      let(:example_result) { "Hello, world!" }

      it "parses successfully" do
        result = binary16.convert(example_base16)
        expect(result).to eq example_result
        expect(result.encoding).to eq Encoding::BINARY
      end
    end

    context "invalid base16 string" do
      let(:invalid_base16) { "Surely this is not valid base16!" }

      it "raises TJSON::ParseError" do
        expect { binary16.convert(invalid_base16) }.to raise_error(TJSON::ParseError)
      end
    end
  end

  describe TJSON::DataType::Binary32 do
    subject(:binary32) { described_class.new }

    context "valid base32 string" do
      let(:example_base32) { "jbswy3dpfqqho33snrscc" }
      let(:example_result) { "Hello, world!" }

      it "parses successfully" do
        result = binary32.convert(example_base32)
        expect(result).to eq example_result
        expect(result.encoding).to eq Encoding::BINARY
      end
    end

    context "padded base32 string" do
      let(:padded_base32) { "jbswy3dpfqqho33snrscc===" }

      it "raises TJSON::ParseError" do
        expect { binary32.convert(padded_base32) }.to raise_error(TJSON::ParseError)
      end
    end

    context "invalid base32 string" do
      let(:invalid_base32) { "Surely this is not valid base32!" }

      it "raises TJSON::ParseError" do
        expect { binary32.convert(invalid_base32) }.to raise_error(TJSON::ParseError)
      end
    end
  end

  describe TJSON::DataType::Binary64 do
    subject(:binary64) { described_class.new }

    context "valid base64url string" do
      let(:example_base64url) { "SGVsbG8sIHdvcmxkIQ" }
      let(:example_result)    { "Hello, world!" }

      it "parses successfully" do
        result = binary64.convert(example_base64url)
        expect(result).to eq example_result
        expect(result.encoding).to eq Encoding::BINARY
      end
    end

    context "padded base64url string" do
      let(:padded_base64url) { "SGVsbG8sIHdvcmxkIQ==" }

      it "raises TJSON::ParseError" do
        expect { binary64.convert(padded_base64url) }.to raise_error(TJSON::ParseError)
      end
    end

    context "invalid base64url string" do
      let(:invalid_base64url) { "Surely this is not valid base64url!" }

      it "raises TJSON::ParseError" do
        expect { binary64.convert(invalid_base64url) }.to raise_error(TJSON::ParseError)
      end
    end
  end
end
