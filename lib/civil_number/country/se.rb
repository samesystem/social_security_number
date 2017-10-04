module CivilNumber
  class Se < Country

    def validate
      @error = if !check_by_regexp(REGEXP)
        'bad number format'
      elsif @birth_date.nil?
        'number birth date is invalid'
      elsif !check_control_digit
        'number control sum invalid'
      end
    end

    private

    MODULUS = 10

    CONTROLCIPHERS = [2, 1, 2, 1, 2, 1, 2, 1, 2].freeze

    REGEXP = /^(?<year>\d{4})(?<month>\d{2})(?<day>\d{2})-(?<individual>\d{2})(?<gender>\d{1})(?<control>\d{1})$/

    def check_control_digit
       sum = checksum(:even)
       control_number = (sum % 10 != 0) ? 10 - (sum % 10) : 0
       control_number == @control_number
    end

    def checksum(operation)
      i = 0
      compare_method = operation == :even ? :== : :>
      number[0..8].reverse.split('').reduce(0) do |sum, c|
        n = c.to_i
        weight = (i % 2).send(compare_method, 0) ? n * 2 : n
        i += 1
        sum += weight < 10 ? weight : weight - 9
      end
    end

    def number
      @civil_number.to_s.gsub(/\D/, '')
    end

    def formatted(string)
      val = string.to_s.gsub(/\D/, '')
      civil_number = val.length == 12 ? val[2...12] : val

      return civil_number if civil_number.length < 10
      civil_number.insert(civil_number.length - 4, "-")
    end

    def base_year(year)
      base = case year[:year].to_i
      when 1..40 then 2000
      when 40..99 then 1900
      else
        0
      end
      base + year[:year].to_i
    end

    def get_gender(code)
      code.odd? ? :female : :male
    end
end
end
