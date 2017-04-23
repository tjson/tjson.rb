# frozen_string_literal: true

RSpec.describe TJSON::DataType::Boolean do
  context "#decode" do
    it "allows true" do
      expect(subject.decode(true)).to eq true
    end

    it "allows false" do
      expect(subject.decode(false)).to eq false
    end

    it "raises TJSON::TypeError on nil" do
      expect { subject.decode(nil) }.to raise_error TJSON::TypeError
    end

    it "raises TJSON::TypeError on other non-boolean values" do
      [42, "a random string", [1, 2, 3]].each do |obj|
        expect { subject.decode(obj) }.to raise_error TJSON::TypeError
      end
    end
  end

  context "#generate" do
    it "could use some tests"
  end
end
