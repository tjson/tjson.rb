# frozen_string_literal: true

RSpec.describe TJSON::DataType::Timestamp do
  context "valid UTC RFC3339 timestamp" do
    let(:example_timestamp) { "2016-10-02T07:31:51Z" }

    it "parses successfully" do
      expect(subject.convert(example_timestamp)).to be_a Time
    end
  end

  context "RFC3339 timestamp with non-UTC time zone" do
    let(:invalid_timestamp) { "2016-10-02T07:31:51-08:00" }

    it "raises TJSON::ParseError" do
      expect { subject.convert(invalid_timestamp) }.to raise_error(TJSON::ParseError)
    end
  end
end
