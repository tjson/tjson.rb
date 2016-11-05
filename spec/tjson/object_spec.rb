# frozen_string_literal: true

RSpec.describe TJSON::Object do
  subject(:object) { described_class.new }

  describe "duplicate member names" do
    let(:example_name) { "foobar:f" }

    it "raises TJSON::DuplicateNameError" do
      object[example_name.dup] = 1
      expect { object[example_name.dup] = 2 }.to raise_error(TJSON::DuplicateNameError)
    end
  end
end
