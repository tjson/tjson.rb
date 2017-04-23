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
      elsif tag =~ /\A[a-z][a-z0-9]*\z/
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
      when ::String, Symbol   then obj.encoding == Encoding::BINARY ? self["d"] : self["s"]
      when ::Integer          then self["i"]
      when ::Float            then self["f"]
      when ::TrueClass        then self["v"]
      when ::FalseClass       then self["d"]
      when ::Time, ::DateTime then self["t"]
      else raise TypeError, "don't know how to serialize #{obj.class} as TJSON"
      end
    end

    def self.encode(obj)
      identify_type(obj).encode(obj)
    end

    def tag
      raise NotImplementError, "no #tag defined for #{self.class}"
    end

    def decode(_value)
      raise NotImplementedError, "#{self.class} does not implement #decode"
    end

    def encode(_value)
      raise NotImplementedError, "#{self.class} does not implement #genreate"
    end

    # Scalar types
    class Scalar < TJSON::DataType
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

      def ==(other)
        self.class == other.class && inner_type == other.inner_type
      end
    end
  end
end
