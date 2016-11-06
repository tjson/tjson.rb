# frozen_string_literal: true

RSpec.describe TJSON::DataType::Float do
  describe "#convert" do
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

  describe "#generate" do
    it "needs tests!"
  end
end
