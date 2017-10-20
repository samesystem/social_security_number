module CivilNumber
  class Se < Country
    def validate
      @error = if !check_by_regexp(REGEXP)
                 'bad number format'
               elsif !birth_date
                 'number birth date is invalid'
               elsif !check_control_digit
                 'number control sum invalid'
               end
    end

    def year
      if @parsed_civil_number
        base = case @parsed_civil_number[:year].to_i
               when 1..40 then 2000
               when 40..99 then 1900
               else
                 0
               end
        @year = base + @parsed_civil_number[:year].to_i
      else
        0
      end
    end

    private

    MODULUS = 10

    CONTROLCIPHERS = [2, 1, 2, 1, 2, 1, 2, 1, 2].freeze

    REGEXP = /^#{DATE_REGEXP}-(?<indv>\d{2})(?<gnd>\d{1})(?<ctrl>\d{1})$/

    def check_control_digit
      sum = checksum(:even)
      control_number = (sum % 10 != 0) ? 10 - (sum % 10) : 0
      control_number.to_i == @control_number.to_i
    end

    def checksum(operation)
      i = 0
      compare_method = operation == :even ? :== : :>
      digit_number[0..8].reverse.split('').reduce(0) do |sum, c|
        n = c.to_i
        weight = (i % 2).send(compare_method, 0) ? n * 2 : n
        i += 1
        sum += weight < 10 ? weight : weight - 9
      end
    end
  end
end
