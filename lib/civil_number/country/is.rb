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

    def day
      d = @parsed_civil_number[:day].to_i
      @day = d >= 40 ? d - 40 : d
    end

    private

    MODULUS = 11

    CONTROLCIPHERS = [3, 2, 7, 6, 5, 4, 3, 2].freeze

    REGEXP = /^(?<day>[01234567]\d)(?<month>\d{2})(?<year>\d{2})[ . -]?(?<indv>\d{2})(?<control>\d{1})(?<century>[09])$/


    def check_control_sum
      count_control_number == @control_number.to_i
    end

    def count_control_number
      sum = calc_sum(digit_number[0..9], CONTROLCIPHERS)
      11 - sum % MODULUS
    end
  end
end