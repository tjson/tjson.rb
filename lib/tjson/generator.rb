# frozen_string_literal: true

module TJSON
  # Generates TJSON from Ruby objects
  module Generator
    module_function

    def generate(obj)
      case obj
      when Hash           then generate_hash(obj)
      when ::Array        then generate_array(obj)
      when String, Symbol then generate_string(obj.to_s)
      when Integer        then generate_integer(obj)
      when Float          then obj
      when Time, DateTime then generate_timestamp(obj.to_time)
      else                     obj.to_tjson
      end
    end

    def generate_hash(hash)
      members = hash.map do |k, v|
        raise TypeError, "expected String for key, got #{k.class}" unless k.is_a?(String)
        [generate(k), generate(v)]
      end

      Hash[members]
    end

    def generate_array(array)
      array.map { |o| generate(o) }
    end

    def generate_string(string)
      if string.encoding == Encoding::BINARY
        TJSON::Binary.base64(string)
      else
        "s:#{string.encode(Encoding::UTF_8)}"
      end
    end

    def generate_integer(int)
      "i:#{int}"
    end

    def generate_timestamp(time)
      "t:#{time.utc.iso8601}"
    end
  end
end
