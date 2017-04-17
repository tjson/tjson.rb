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
        inner = parse(result[:inner]) unless result[:inner].empty?
        TJSON::DataType[result[:type]].new(inner).freeze
      elsif tag.match?(/\A[a-z][a-z0-9]*\z/)
        # Scalar
        TJSON::DataType[tag]
      else
        raise TJSON::ParseError, "couldn't parse tag: #{tag.inspect}" unless result
      end
    end

    def self.identify_type(obj)
      case obj
      when Hash               then self["O"]
      when ::Array            then TJSON::DataType::Array.identify_type(obj)
      when ::Set              then TJSON::DataType::Set.identify_type(obj)
      when ::String, Symbol   then obj.encoding == Encoding::BINARY ? self["b"] : self["s"]
      when ::Integer          then self["i"]
      when ::Float            then self["f"]
      when ::TrueClass        then self["v"]
      when ::FalseClass       then self["v"]
      when ::Time, ::DateTime then self["t"]
      else raise TypeError, "don't know how to serialize #{obj.class} as TJSON"
      end
    end

    def self.generate(obj)
      identify_type(obj).generate(obj)
    end

    def tag
      raise NotImplementError, "no #tag defined for #{self.class}"
    end

    def convert(_value)
      raise NotImplementedError, "#{self.class} does not implement #convert"
    end

    def generate(_value)
      raise NotImplementedError, "#{self.class} does not implement #genreate"
    end

    # Scalar types
    class Scalar < TJSON::DataType
      def scalar?
        true
      end

      def inspect
        "#<#{self.class}>"
      end
    end

    # Non-scalar types
    class NonScalar < TJSON::DataType
      attr_reader :inner_type

      def initialize(inner_type)
        @inner_type = inner_type
      end

      def inspect
        "#<#{self.class}<#{@inner_type.inspect}>>"
      end

      def scalar?
        false
      end

      def ==(other)
        self.class == other.class && inner_type == other.inner_type
      end
    end

    # Numbers
    class Number < Scalar; end
  end
end

require "tjson/datatype/array"
require "tjson/datatype/binary"
require "tjson/datatype/float"
require "tjson/datatype/integer"
require "tjson/datatype/set"
require "tjson/datatype/string"
require "tjson/datatype/timestamp"
require "tjson/datatype/object"
require "tjson/datatype/value"

# TJSON does not presently support user-extensible types
TJSON::DataType::TAGS = {
  # Object (non-scalar with self-describing types)
  "O" => TJSON::DataType::Object.new(nil).freeze,

  # Non-scalars
  "A" => TJSON::DataType::Array,
  "S" => TJSON::DataType::Set,

  # Scalars
  "b"   => TJSON::DataType::Binary64.new.freeze,
  "b16" => TJSON::DataType::Binary16.new.freeze,
  "b32" => TJSON::DataType::Binary32.new.freeze,
  "b64" => TJSON::DataType::Binary64.new.freeze,
  "f"   => TJSON::DataType::Float.new.freeze,
  "i"   => TJSON::DataType::SignedInt.new.freeze,
  "s"   => TJSON::DataType::String.new.freeze,
  "t"   => TJSON::DataType::Timestamp.new.freeze,
  "u"   => TJSON::DataType::UnsignedInt.new.freeze,
  "v"   => TJSON::DataType::Value.new.freeze
}.freeze
