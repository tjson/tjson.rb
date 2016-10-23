# frozen_string_literal: true

RSpec.describe TJSON::TagParser do
  describe ".parse" do
    context "UTF-8 strings" do
      let(:example_result) { "hello, world!" }
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
    context "valid base16 string" do
      let(:example_base16) { "48656c6c6f2c20776f726c6421" }
      let(:example_result) { "Hello, world!" }

      it "parses successfully" do
        result = described_class.from_base16(example_base16)
        expect(result).to eq example_result
        expect(result.encoding).to eq Encoding::BINARY
      end
    end

    context "invalid base16 string" do
      let(:invalid_base16) { "Surely this is not valid base16!" }

      it "raises TJSON::ParseError" do
        expect { described_class.from_base16(invalid_base16) }.to raise_error(TJSON::ParseError)
      end
    end
  end

  describe ".from_base64url" do
    context "valid base64url string" do
      let(:example_base64url) { "SGVsbG8sIHdvcmxkIQ" }
      let(:example_result)    { "Hello, world!" }

      it "parses successfully" do
        result = described_class.from_base64url(example_base64url)
        expect(result).to eq example_result
        expect(result.encoding).to eq Encoding::BINARY
      end
    end

    context "padded base64url string" do
      let(:padded_base64url) { "SGVsbG8sIHdvcmxkIQ==" }

      it "raises TJSON::ParseError" do
        expect { described_class.from_base16(padded_base64url) }.to raise_error(TJSON::ParseError)
      end
    end

    context "invalid base64url string" do
      let(:invalid_base64url) { "Surely this is not valid base64url!" }

      it "raises TJSON::ParseError" do
        expect { described_class.from_base16(invalid_base64url) }.to raise_error(TJSON::ParseError)
      end
    end
  end

  describe ".from_integer" do
    context "valid integer string" do
      let(:example_string)  { "42" }
      let(:example_integer) { 42 }

      it "parses successfully" do
        expect(described_class.from_integer(example_string)).to eq example_integer
      end
    end

    context "MAXINT for sized 64-bit integer" do
      let(:example_string)  { "9223372036854775807" }
      let(:example_integer) { (2**63) - 1 }

      it "parses successfully" do
        expect(described_class.from_integer(example_string)).to eq example_integer
      end
    end

    context "-MAXINT for sized 64-bit integer" do
      let(:example_string)  { "-9223372036854775808" }
      let(:example_integer) { -(2**63) }

      it "parses successfully" do
        expect(described_class.from_integer(example_string)).to eq example_integer
      end
    end

    context "oversized integer string" do
      let(:oversized_example) { "9223372036854775808" }

      it "raises TJSON::ParseError" do
        expect { described_class.from_integer(oversized_example) }.to raise_error(TJSON::ParseError)
      end
    end

    context "undersized integer string" do
      let(:oversized_example) { "-9223372036854775809" }

      it "raises TJSON::ParseError" do
        expect { described_class.from_integer(oversized_example) }.to raise_error(TJSON::ParseError)
      end
    end
  end

  describe ".from_timestamp" do
    context "valid UTC RFC3339 timestamp" do
      let(:example_timestamp) { "2016-10-02T07:31:51Z" }

      it "parses successfully" do
        expect(described_class.from_timestamp(example_timestamp)).to be_a Time
      end
    end

    context "RFC3339 timestamp with non-UTC time zone" do
      let(:invalid_timestamp) { "2016-10-02T07:31:51-08:00" }

      it "raises TJSON::ParseError" do
        expect { described_class.from_timestamp(invalid_timestamp) }.to raise_error(TJSON::ParseError)
      end
    end
  end
end
