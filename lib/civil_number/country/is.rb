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
      @day = @parsed_civil_number[:day].to_i % 40
    end

    private

    MODULUS = 11

    CONTROLCIPHERS = [3, 2, 7, 6, 5, 4, 3, 2].freeze

    DATE_REGEXP = /(?<day>[01234567]\d)(?<month>\d{2})(?<year>\d{2})/
    REGEXP = /^#{DATE_REGEXP}[ .-]?(?<indv>\d{2})(?<ctrl>\d{1})(?<cntr>[09])$/


    def check_control_sum
      count_control_number == @control_number.to_i
    end

    def count_control_number
      sum = calc_sum(digit_number[0..9], CONTROLCIPHERS)
      11 - sum % MODULUS
    end
  end
end
