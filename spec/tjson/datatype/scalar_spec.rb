# frozen_string_literal: true

RSpec.describe TJSON::DataType::Scalar do
  subject(:scalar) { described_class.new }

  it "knows it's a scalar" do
    expect(scalar).to be_scalar
  end
end
