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

    private

    MODULUS = 11

    REGEXP = /^(?<year>\d{2})[- .]?(?<month>\d{2})[- .]?(?<day>\d{2})[- .\/]?(?<individual>\d{3})[- .]?(?<control>\d{1})?$/

    def check_control_sum
      if @control_number.to_s != ''
        count_last_number == @control_number.to_i || (count_last_number == 10 && @control_number.to_i == 0 && @year < 1986)
      else
        true
      end
    end

    def count_last_number
      number[0..8].to_i % MODULUS
    end

    def base_year(year)
      current_year = Time.now.year % 100
      offset_year = year[:year].to_i
      offset_year += 100 if year[:year] && (offset_year < current_year)
      1900 + offset_year
    end

    def gender_from_number
      (matches = @civil_number.match(REGEXP)) || (return nil)
      matches[:month].to_i > 32 ? :famale : :male
    end

    def get_month(month)
      if month.to_i < 33
        month.to_i > 12 ? month.to_i - 20 : month.to_i
      else
        month.to_i > 62 ? month.to_i - 70 : month.to_i - 50
      end
    end

    def number
      @civil_number.gsub(/[^\d]/, '')
    end
  end
end
