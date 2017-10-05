module CivilNumber
  class Be < Country
    def validate
      @error = if !check_by_regexp(REGEXP)
                 'bad number format'
               elsif !(1..997).member?(@individual.to_i)
                 'individual number is invalid'
               elsif !birth_date && @month.to_i != 0 && @day.to_i != 0
                 'number birth date is invalid'
               elsif !check_control_sum
                 'number control sum invalid'
      end
    end

    private

    MODULUS = 11

    CONTROLCIPHERS_1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 1].freeze
    CONTROLCIPHERS_2 = [3, 4, 5, 6, 7, 8, 9, 1, 2, 3].freeze

    REGEXP = /^(?<year>\d{2})[- .]?(?<month>\d{2})[- .]?(?<day>\d{2})[- .]?(?<individual>\d{3})[- .]?(?<control>\d{2})$/

    def check_control_sum
      count_last_number == @control_number || count_last_number('2') == @control_number
    end

    def count_last_number(number = '0')
      97 - (("#{number}#{@year}#{@month}#{@day}#{@individual}").to_i % 97)
    end

    def base_year(year)
      current_year = Time.now.year % 100
      offset_year = year[:year].to_i
      offset_year += 100 if year[:year] && (offset_year < current_year)
      1900 + offset_year
    end

    def get_gender(_code)
      @individual.odd? ? :male : :female
    end
  end
end
