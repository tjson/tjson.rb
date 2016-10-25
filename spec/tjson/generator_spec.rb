# frozen_string_literal: true

RSpec.describe TJSON::Generator do
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

  describe ".generate_hash" do
    it "needs tests!"
  end

  describe ".generate_array" do
    it "needs tests!"
  end

  describe ".generate_string" do
    it "needs tests!"
  end

  describe ".generate_integer" do
    it "needs tests!"
  end

  describe ".generate_timestamp" do
    it "needs tests!"
  end
end
