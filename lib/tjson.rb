# frozen_string_literal: true

require "tjson/version"

require "json"
require "time"
require "base32"
require "base64"

require "tjson/array"
require "tjson/generator"
require "tjson/object"
require "tjson/parser"

# Tagged JSON with Rich Types
module TJSON
  # Base class of all TJSON errors
  Error = Class.new(StandardError)

  # Invalid string encoding
  EncodingError = Class.new(Error)

  # Failure to parse TJSON document
  ParseError = Class.new(Error)

  # Duplicate object name
  DuplicateNameError = Class.new(ParseError)

  # Maximum allowed nesting (TODO: use TJSON-specified maximum)
  MAX_NESTING = 100

  # Parse the given UTF-8 string as TJSON
  #
  # @param string [String] TJSON string to be parsed
  # @raise [TJSON::ParseError] an error occurred parsing the given TJSON
  # @return [Object] parsed data
  def self.parse(string)
    begin
      utf8_string = string.encode(Encoding::UTF_8)
    rescue ::EncodingError => ex
      raise TJSON::EncodingError, ex.message, ex.backtrace
    end

    begin
      ::JSON.parse(
        utf8_string,
        max_nesting:      MAX_NESTING,
        allow_nan:        false,
        symbolize_names:  false,
        create_additions: false,
        object_class:     TJSON::Object,
        array_class:      TJSON::Array
      )
    rescue ::JSON::ParserError => ex
      raise TJSON::ParseError, ex.message, ex.backtrace
    end
  end

  # Generate TJSON from a Ruby Hash or Array
  #
  # @param obj [Array, Hash] Ruby Hash or Array to serialize as TJSON
  # @return [String] serialized TJSON
  def self.generate(obj)
    raise TypeError, "expected Hash or Array, got #{obj.class}" unless obj.is_a?(Hash) || obj.is_a?(Array)
    JSON.generate(TJSON::Generator.generate(obj))
  end
end
