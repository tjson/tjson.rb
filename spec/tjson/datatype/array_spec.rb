# frozen_string_literal: true

RSpec.describe TJSON::DataType::Array do
  describe ".identify_type" do
    context "homogenous array" do
      let(:example_array) { [1, 2, 3] }

      it "determines the type" do
        type = described_class.identify_type(example_array)
        expect(type).to be_a described_class
        expect(type.inner_type).to be_a TJSON::DataType::SignedInt
      end
    end

    context "nested array" do
      let(:example_array) { [[1, 2], [3, 4]] }

      it "determines the type" do
        type = described_class.identify_type(example_array)
        expect(type).to be_a described_class

        inner = type.inner_type
        expect(inner).to be_a described_class
        expect(inner.inner_type).to be_a TJSON::DataType::SignedInt
      end
    end

    context "heterogenous array" do
      let(:heterogenous_array) { ["foo", "bar", 42] }

      it "raises TJSON::TypeError" do
        expect { described_class.identify_type(heterogenous_array) }.to raise_error(TJSON::TypeError)
      end
    end
  end

  describe "#convert" do
    it "needs tests!"
  end

  describe "#generate" do
    it "needs tests!"
  end
end
