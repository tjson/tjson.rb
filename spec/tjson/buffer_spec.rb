# frozen_string_literal: true

RSpec.describe TJSON::Binary do
  let(:example_string) { "Hello, world!" }

  describe ".base16" do
    it "serializes base16" do
      expect(described_class.base16(example_string)).to eq "b16:48656c6c6f2c20776f726c6421"
    end
  end

  describe ".base32" do
    it "serializes base32" do
      expect(described_class.base32(example_string)).to eq "b32:jbswy3dpfqqho33snrscc"
    end
  end

  describe ".base64" do
    it "serializes base64url" do
      expect(described_class.base64(example_string)).to eq "b64:SGVsbG8sIHdvcmxkIQ"
    end
  end
end
