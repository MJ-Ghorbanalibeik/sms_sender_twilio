module SmsSenderTwilio
  module Normalizer
    # To implement this standard: http://en.wikipedia.org/wiki/E.164
    def self.normalize_number_e_164(number)
      n=number.dup
      while n.starts_with?('0')
        n.slice!(0)
      end
      n = '+' + n unless n.starts_with?('+')
      return n
    end

    def self.normalize_message(message)
      m=message.dup
      if message.length > 1600
        m = m[0..1599]
      end
      return m
    end
  end
end
