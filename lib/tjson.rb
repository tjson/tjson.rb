# frozen_string_literal: true

require "tjson/version"

require "json"

# Tagged JSON with Rich Types
module TJSON
  # Base class of all TJSON errors
  Error = Class.new(StandardError)

  # Invalid string encoding
  EncodingError = Class.new(Error)

  # Failure to parse TJSON document
  ParseError = Class.new(Error)

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
      raw_json = ::JSON.parse(utf8_string)
    rescue ::JSON::ParserError => ex
      raise TJSON::ParseError, ex.message, ex.backtrace
    end

    # TODO: this needs to be postprocessed
    raw_json
  end
end
