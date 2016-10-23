# frozen_string_literal: true

RSpec.describe TJSON::Object do
  subject(:object) { described_class.new }

  describe "member name types" do
    let(:example_value) { "s:bar".dup }

    context "Unicode Strings" do
      let(:example_name) { "s:foo".dup }

      it "parses successfully" do
        expect { object[example_name] = example_value }.not_to raise_error
      end
    end

    context "Binary Data" do
      let(:example_name) { "b16:48656c6c6f2c20776f726c6421".dup }

      it "parses successfully" do
        expect { object[example_name] = example_value }.not_to raise_error
      end
    end

    context "types other than Unicode Strings or Binary Data" do
      let(:example_name) { "i:42".dup }

      it "raises TJSON::ParseError" do
        expect { object[example_name] = example_value }.to raise_error(TJSON::ParseError)
      end
    end
  end
end
