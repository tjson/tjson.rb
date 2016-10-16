# frozen_string_literal: true

require "tjson/version"

require "json"

require "tjson/array"
require "tjson/binary"
require "tjson/object"
require "tjson/tag_parser"

# Tagged JSON with Rich Types
module TJSON
  # Base class of all TJSON errors
  Error = Class.new(StandardError)

  # Invalid string encoding
  EncodingError = Class.new(Error)

  # Failure to parse TJSON document
  ParseError = Class.new(Error)

  # Maximum allowed nesting (TODO: use TJSON-specified maximum)
  MAX_NESTING = 100

  # Parse the given UTF-8 string as TJSON
  #
  # @raise []
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
end
