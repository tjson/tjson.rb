# frozen_string_literal: true

RSpec.describe TJSON::DataType::Number do
  describe TJSON::DataType::Float do
    context "floating point value" do
      let(:example_float) { 42.0 }

      it "parses successfully" do
        expect(subject.convert(example_float)).to eq example_float
      end
    end

    context "integer value" do
      let(:example_integer) { 42 }

      it "coerces to float" do
        expect(subject.convert(example_integer)).to eq example_integer.to_f
      end
    end

    context "non-numeric value" do
      let(:example_string) { "42" }

      it "raise TJSON::TypError" do
        expect { subject.convert(example_string) }.to raise_error(TJSON::TypeError)
      end
    end
  end

  describe TJSON::DataType::SignedInt do
    context "valid integer string" do
      let(:example_string)  { "42" }
      let(:example_integer) { 42 }

      it "parses successfully" do
        expect(subject.convert(example_string)).to eq example_integer
      end
    end

    context "MAXINT for 64-bit signed integer" do
      let(:example_string)  { "9223372036854775807" }
      let(:example_integer) { (2**63) - 1 }

      it "parses successfully" do
        expect(subject.convert(example_string)).to eq example_integer
      end
    end

    context "-MAXINT for 64-bit signed integer" do
      let(:example_string)  { "-9223372036854775808" }
      let(:example_integer) { -(2**63) }

      it "parses successfully" do
        expect(subject.convert(example_string)).to eq example_integer
      end
    end

    context "oversized signed integer string" do
      let(:oversized_example) { "9223372036854775808" }

      it "raises TJSON::ParseError" do
        expect { subject.convert(oversized_example) }.to raise_error(TJSON::ParseError)
      end
    end

    context "undersized signed integer string" do
      let(:oversized_example) { "-9223372036854775809" }

      it "raises TJSON::ParseError" do
        expect { subject.convert(oversized_example) }.to raise_error(TJSON::ParseError)
      end
    end
  end

  describe TJSON::DataType::UnsignedInt do
    context "valid integer string" do
      let(:example_string)  { "42" }
      let(:example_integer) { 42 }

      it "parses successfully" do
        expect(subject.convert(example_string)).to eq example_integer
      end
    end

    context "MAXINT for 64-bit unsigned integer" do
      let(:example_string)  { "18446744073709551615" }
      let(:example_integer) { (2**64) - 1 }

      it "parses successfully" do
        expect(subject.convert(example_string)).to eq example_integer
      end
    end

    context "oversized unsigned integer string" do
      let(:oversized_example) { "18446744073709551616" }

      it "raises TJSON::ParseError" do
        expect { subject.convert(oversized_example) }.to raise_error(TJSON::ParseError)
      end
    end

    context "negative unsigned integer" do
      let(:example_string) { "-1" }

      it "raises TJSON::ParseError" do
        expect { subject.convert(example_string) }.to raise_error(TJSON::ParseError)
      end
    end
  end
end
