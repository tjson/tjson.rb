# frozen_string_literal: true

require "tjson/version"

require "json"
require "set"
require "time"

require "base32"
require "base64"

require "tjson/datatype"
require "tjson/object"

# Tagged JSON with Rich Types
module TJSON
  # Base class of all TJSON errors
  Error = Class.new(StandardError)

  # Invalid string encoding
  EncodingError = Class.new(Error)

  # Failure to parse TJSON document
  ParseError = Class.new(Error)

  # Invalid types
  TypeError = Class.new(ParseError)

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
      object = ::JSON.parse(
        utf8_string,
        max_nesting:      MAX_NESTING,
        allow_nan:        false,
        symbolize_names:  false,
        create_additions: false,
        object_class:     TJSON::Object
      )
    rescue ::JSON::ParserError => ex
      raise TJSON::ParseError, ex.message, ex.backtrace
    end

    raise TJSON::TypeError, "invalid toplevel type: #{object.class}" unless object.is_a?(TJSON::Object)
    object
  end

  class << self
    alias load parse
  end

  # Load data from a file containing TJSON
  #
  # @param filename [String] name of the .tjson file
  # @raise [TJSON::ParseError] an error occurred parsing the given file
  # @return [Object] parsed data
  def self.load_file(filename)
    load(File.read(filename))
  end

  # Generate TJSON from a Ruby Hash (TJSON only allows objects as toplevel values)
  #
  # @param obj [Hash] Ruby Hash to serialize as TJSON
  # @return [String] serialized TJSON
  def self.generate(obj)
    raise TypeError, "toplevel type must be a Hash" unless obj.is_a?(Hash)
    JSON.generate(TJSON::DataType.generate(obj))
  end

  # Generate TJSON from a Ruby Hash (TJSON only allows objects as toplevel values)
  #
  # @param obj [Hash] Ruby Hash to serialize as TJSON
  # @return [String] serialized TJSON
  def self.pretty_generate(obj)
    raise TypeError, "toplevel type must be a Hash" unless obj.is_a?(Hash)
    JSON.pretty_generate(TJSON::DataType.generate(obj))
  end
end
