# frozen_string_literal: true

module TJSON
  # TJSON object type (i.e. hash/dict-alike)
  class Object < ::Hash
    def []=(tagged_name, value)
      # NOTE: this regex is sloppy. The real parsing is performed in TJSON::DataType#parse
      result = tagged_name.match(/\A(?<name>.*):(?<tag>[A-Za-z0-9\<]+[\>]*)\z/)

      raise ParseError, "invalid tag: #{tagged_name.inspect}" unless result
      raise DuplicateNameError, "duplicate member name: #{result[:name].inspect}" if key?(result[:name])

      type = TJSON::DataType.parse(result[:tag])
      super(result[:name], type.convert(value))
    end
  end
end
