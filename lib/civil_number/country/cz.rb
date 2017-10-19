module CivilNumber
  class Cz < Country
    # https://en.wikipedia.org/wiki/National_identification_number#Czech_Republic_and_Slovakia
    # https://www.npmjs.com/package/rodnecislo
    # http://lorenc.info/3MA381/overeni-spravnosti-rodneho-cisla.htm
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
      m = @parsed_civil_number[:month]
      @month = if m.to_i < 33
                 m.to_i > 12 ? m.to_i - 20 : m.to_i
               else
                 m.to_i > 62 ? m.to_i - 70 : m.to_i - 50
               end
    end

    private

    MODULUS = 11

    REGEXP = %r{^(?<year>\d{2})[- .]?(?<month>\d{2})[- .]?(?<day>\d{2})[- .\/]?(?<indv>\d{3})[- .]?(?<control>\d{1})?$}

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
