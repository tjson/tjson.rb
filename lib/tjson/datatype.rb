# frozen_string_literal: true

module TJSON
  # Hierarchy of TJSON types
  class DataType
    # Find a type by its tag
    def self.[](tag)
      TAGS[tag] || raise(TJSON::TypeError, "unknown tag: #{tag.inspect}")
    end

    def self.parse(tag)
      raise TJSON::TypeError, "expected String, got #{tag.class}" unless tag.is_a?(::String)

      if tag == "O"
        # Object
        TJSON::DataType[tag]
      elsif (result = tag.match(/\A(?<type>[A-Z][a-z0-9]*)\<(?<inner>.*)\>\z/))
        # Non-scalar
        TJSON::DataType[result[:type]].new(parse(result[:inner])).freeze
      elsif tag =~ /\A[a-z][a-z0-9]*\z/
        # Scalar
        TJSON::DataType[tag]
      else
        raise TJSON::ParseError, "couldn't parse tag: #{tag.inspect}" unless result
      end
    end
  end
end

require "tjson/datatype/nonscalar"
require "tjson/datatype/scalar"

require "tjson/datatype/binary"
require "tjson/datatype/number"
require "tjson/datatype/string"
require "tjson/datatype/timestamp"

# TJSON does not presently support user-extensible types
TJSON::DataType::TAGS = {
  # Object (non-scalar with self-describing types)
  "O" => TJSON::DataType::Object.new(nil).freeze,

  # Non-scalars
  "A" => TJSON::DataType::Array,

  # Scalars
  "b"   => TJSON::DataType::Binary64.new.freeze,
  "b16" => TJSON::DataType::Binary16.new.freeze,
  "b32" => TJSON::DataType::Binary32.new.freeze,
  "b64" => TJSON::DataType::Binary64.new.freeze,
  "f"   => TJSON::DataType::Float.new.freeze,
  "i"   => TJSON::DataType::SignedInt.new.freeze,
  "s"   => TJSON::DataType::String.new.freeze,
  "t"   => TJSON::DataType::Timestamp.new.freeze,
  "u"   => TJSON::DataType::UnsignedInt.new.freeze
}.freeze
