# frozen_string_literal: true

require "uri"
require "net/http"
require "toml"

# Load standard test cases from the TJSON specification
class ExampleLoader
  attr_reader :examples

  # Location of the example file
  # TODO: when this stabilizes, vendor it into the project so we don't have an online dependency
  TJSON_EXAMPLES_URL = "https://raw.githubusercontent.com/tjson/tjson-spec/master/draft-tjson-examples.txt"

  # Delimiter used to separate examples
  EXAMPLES_DELIMITER = /^-----$/m

  # Raised if we're unable to parse the examples
  ParseError = Class.new(StandardError)

  def initialize(uri = TJSON_EXAMPLES_URL)
    @uri = URI(uri)
    @examples = parse_examples(Net::HTTP.get(@uri))
  end

  private

  def parse_examples(examples_text)
    # Strip comments
    examples_text.gsub!(/^#.*?\n/m, "")

    # Split examples on the "-----" delimiter
    examples = examples_text.split(EXAMPLES_DELIMITER)

    # There shouldn't be anything except whitespace before the first delimiter
    raise ParseError, "unexpected data before leading '-----'" unless examples.shift =~ /\A\s*\z/

    # There shouldn't be anything except whitespace after the last delimiter
    raise ParseError, "unexpected data before trailing '-----'" unless examples.pop =~ /\A\s*\z/

    examples.map.with_index do |example, index|
      # Split each example on the "%%%" delimiter
      metadata_text, data, extra = example.split(/\n\s*\n/m)
      raise ParserError, "extra %%% (example #{index + 1})" unless extra.nil?

      # Strip leading newline from metadata
      metadata_text.sub!(/\A\n/m, "")

      begin
        metadata = TOML.parse(metadata_text)
      rescue TOML::ParseError => ex
        raise ParseError, "bad TOML in metadata (example \##{number + 1}): #{ex.message}", ex.backtrace
      end

      Example.new(data, metadata)
    end
  end

  class Example
    # Keys which must be included in each example's metadata
    MANDATORY_KEYS = %w[name description result].freeze

    attr_reader :name, :description, :data

    def initialize(data, metadata = {})
      @metadata = metadata

      @metadata.each do |key, _value|
        raise ParseError, "unknown metadata key: #{key} (example \##{number + 1})" unless MANDATORY_KEYS.include?(key)
      end

      @name        = @metadata.delete("name").freeze
      @description = @metadata.delete("description").freeze

      result = @metadata.delete("result")

      case result
      when "success" then @success = true
      when "error"   then @success = false
      else raise ParseError, "unknown result type: #{result}"
      end

      @metadata.freeze
      @data = data.strip.freeze
    end

    def success?
      @success
    end

    def [](key)
      @metadata[String(key)]
    end
  end
end
