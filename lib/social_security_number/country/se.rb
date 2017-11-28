module SocialSecurityNumber
  # SocialSecurityNumber::Se validates Sweden Personal Identity Number (personnummer)
  # https://en.wikipedia.org/wiki/National_identification_number#Sweden
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

    YEAR_REGEXP = /(?<year>((?<century>\d{2})(?<year1>\d{2})|(\d{2})))/
    DATE_REGEXP = /#{YEAR_REGEXP}(?<month>\d{2})(?<day>\d{2})/
    REGEXP = /^#{DATE_REGEXP}[- ]?(?<indv>\d{2})(?<gnd>\d{1})(?<ctrl>\d{1})$/

    def check_control_digit
      sum = checksum(:even)
      control_number = (sum % 10 != 0) ? 10 - (sum % 10) : 0
      control_number.to_i == @control_number.to_i
    end

    def checksum(operation)
      i = 0
      compare_method = operation == :even ? :== : :>
      numer = "#{@year.to_s[2..3]}#{@month}#{@day}#{@individual}#{@parsed_civil_number[:gnd]}"
      numer.reverse.split('').reduce(0) do |sum, c|
        n = c.to_i
        weight = (i % 2).send(compare_method, 0) ? n * 2 : n
        i += 1
        sum += weight < 10 ? weight : weight - 9
      end
    end
  end
end
