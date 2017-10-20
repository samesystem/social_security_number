module CivilNumber
  # CivilNumber::Ca validates Canadian Social Insurance Numbers (SINs)
  # The Social Insurance Number (SIN) is a 9-digit identifier issued to
  # individuals for various government programs. SINs that begin with a 9 are
  # issued to temporary workers who are neither Canadian citizens nor permanent
  # residents.
  # https://en.wikipedia.org/wiki/Social_Insurance_Number
  class Ca < Country
    def validate
      @error = if !check_by_regexp(REGEXP)
                 'bad number format'
               elsif !check_number
                 'number control sum invalid'
               end
    end

    private

    MODULUS = 10

    CONTROLCIPHERS = [1, 2, 1, 2, 1, 2, 1, 2, 1].freeze

    REGEXP = /^(?<firs_number>\d{3})[- .]?(?<second_number>\d{3})[- .]?(?<last_number>\d{3})$/

    def check_number
      (count_number_sum % 10).zero?
    end

    def count_number_sum
      digits = digit_number.split(//)
      new_number = []
      sum = 0
      digits.each_with_index do |digit, i|
        n = digit.to_i * CONTROLCIPHERS[i].to_i
        if n > 9
          new_number << n - 9
        else
          new_number << n
        end
      end

      new_number.each do |digit|
        sum += digit.to_i
      end
      sum
    end
  end
end
