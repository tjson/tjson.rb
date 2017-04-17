# frozen_string_literal: true

RSpec.describe TJSON::DataType do
  describe ".identify_type" do
    it "needs tests!"
  end

  describe ".generate" do
    let(:example_structure) do
      {
        "hash"  => { "foo" => "bar" },
        "array" => [1, 2, 3],
        "float" => 0.123,
        "int"   => 42,
        "bin"   => "BINARY".dup.force_encoding(Encoding::BINARY),
        "ts"    => Time.at(Time.now.to_i)
      }
    end

    it "round trips an example structure" do
      tjson = TJSON.generate(example_structure)
      expect(TJSON.parse(tjson)).to eq example_structure
    end
  end

  context "scalars" do
    context "binary data" do
      it "parses base16 tags" do
        expect(described_class.parse("b16")).to be_a TJSON::DataType::Binary16
      end

      it "parses base32 tags" do
        expect(described_class.parse("b32")).to be_a TJSON::DataType::Binary32
      end

      it "parses base64url tags" do
        expect(described_class.parse("b64")).to be_a TJSON::DataType::Binary64
      end

      it "parses implicit base64url tags" do
        expect(described_class.parse("b")).to be_a TJSON::DataType::Binary64
      end
    end

    context "numbers" do
      it "parses float tags" do
        expect(described_class.parse("f")).to be_a TJSON::DataType::Float
      end

      it "parses signed integer tags" do
        expect(described_class.parse("i")).to be_a TJSON::DataType::SignedInt
      end

      it "parses unsigned integer tags" do
        expect(described_class.parse("u")).to be_a TJSON::DataType::UnsignedInt
      end
    end

    it "parses string tags" do
      expect(described_class.parse("s")).to be_a TJSON::DataType::String
    end

    it "parses timestamp tags" do
      expect(described_class.parse("t")).to be_a TJSON::DataType::Timestamp
    end
  end

  context "nonscalars" do
    it "parses array tags" do
      result = described_class.parse("A<i>")
      expect(result).to be_a TJSON::DataType::Array
      expect(result.inner_type).to be_a TJSON::DataType::SignedInt
    end

    it "parses nested array tags" do
      result = described_class.parse("A<A<i>>")
      expect(result).to be_a TJSON::DataType::Array

      inner = result.inner_type
      expect(inner).to be_a TJSON::DataType::Array
      expect(inner.inner_type).to be_a TJSON::DataType::SignedInt
    end

    it "parses object tags" do
      expect(described_class.parse("O")).to be_a TJSON::DataType::Object
    end

    it "parses arrays of objects" do
      result = described_class.parse("A<O>")
      expect(result).to be_a TJSON::DataType::Array
      expect(result.inner_type).to be_a TJSON::DataType::Object
    end
  end

  context "invalid tag" do
    let(:invalid_tag) { "X<b64>" }

    it "raises TJSON::TypeError" do
      expect { described_class.parse(invalid_tag) }.to raise_error(TJSON::TypeError)
    end
  end
end
