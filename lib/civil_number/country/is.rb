module CivilNumber
  class Is < Country
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

    CONTROLCIPHERS = [3,2,7,6,5,4,3,2,].freeze

    REGEXP = /^(?<day>[01234567]\d)(?<month>\d{2})(?<year>\d{2})[ . -]?(?<individual>\d{2})(?<control>\d{1})(?<century>[09])$/


    def check_control_sum

      count_control_number == @control_number.to_i
    end

    def count_control_number
      sum = calc_sum(get_digit_number[0..9], CONTROLCIPHERS)
      11 - sum % MODULUS
    end

    def get_day(day)
      day.to_i >= 40 ? day.to_i - 40 : day.to_i
    end

    def base_year(year)
      current_year = Time.now.year % 100
      offset_year = year[:year].to_i
      offset_year += 100 if year[:year] and offset_year < current_year
      1900 + offset_year
    end
  end
end
