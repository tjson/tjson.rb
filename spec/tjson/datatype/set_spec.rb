# frozen_string_literal: true

RSpec.describe TJSON::DataType::Set do
  describe ".identify_type" do
    context "homogenous set" do
      let(:example_set) { Set.new([1, 2, 3]) }

      it "determines the type" do
        type = described_class.identify_type(example_set)
        expect(type).to be_a described_class
        expect(type.inner_type).to be_a TJSON::DataType::SignedInt
      end
    end

    context "nested set" do
      let(:example_set) { Set.new([Set.new([1, 2]), Set.new([3, 4])]) }

      it "determines the type" do
        type = described_class.identify_type(example_set)
        expect(type).to be_a described_class

        inner = type.inner_type
        expect(inner).to be_a described_class
        expect(inner.inner_type).to be_a TJSON::DataType::SignedInt
      end
    end

    context "heterogenous set" do
      let(:heterogenous_set) { Set.new(["foo", "bar", 42]) }

      it "raises TJSON::TypeError" do
        expect { described_class.identify_type(heterogenous_set) }.to raise_error(TJSON::TypeError)
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
