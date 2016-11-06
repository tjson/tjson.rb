# frozen_string_literal: true

RSpec.describe TJSON::DataType::NonScalar do
  subject(:nonscalar) { described_class.new(nil) }

  it "knows it's not a scalar" do
    expect(nonscalar).not_to be_scalar
  end

  describe TJSON::DataType::Array do
    it "needs tests!"
  end

  describe TJSON::DataType::Object do
    it "needs tests!"
  end
end
