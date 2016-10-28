# frozen_string_literal: true

module TJSON
  # Binary serialization helpers
  module Binary
    module_function

    def base16(string)
      "b16:#{string.unpack('H*').first}"
    end

    def base32(string)
      "b32:#{Base32.encode(string).downcase.delete('=')}"
    end

    def base64(string)
      "b64:#{Base64.urlsafe_encode64(string).delete('=')}"
    end
  end
end
