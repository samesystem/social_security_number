module SocialSecurityNumber
  # SocialSecurityNumber::Cz validates Czech birth numbers
  # https://en.wikipedia.org/wiki/National_identification_number#Czech_Republic_and_Slovakia
  # https://www.npmjs.com/package/rodnecislo
  # http://lorenc.info/3MA381/overeni-spravnosti-rodneho-cisla.htm
  class Cz < Country
    def validate
      @error = if !check_by_regexp(REGEXP)
                 'bad number format'
               elsif !birth_date
                 'number birth date is invalid'
               elsif !check_control_sum
                 'number control sum invalid'
               end
    end

    def gender
      @gender = @parsed_civil_number[:month].to_i > 32 ? :famale : :male
    end

    def month
      @month = (@parsed_civil_number[:month].to_i % 50) % 20
    end

    private

    MODULUS = 11

    DATE_REGEXP = /(?<year>\d{2})[- .]?(?<month>\d{2})[- .]?(?<day>\d{2})/
    REGEXP = %r{^#{DATE_REGEXP}[- .\/]?(?<indv>\d{3})[- .]?(?<ctrl>\d{1})?$}

    def check_control_sum
      if @control_number.to_s != ''
        count_last_number == @control_number.to_i ||
          (count_last_number == 10 &&
            @control_number.to_i.zero? && @year < 1986)
      else
        true
      end
    end

    def count_last_number
      digit_number[0..8].to_i % MODULUS
    end
  end
end
