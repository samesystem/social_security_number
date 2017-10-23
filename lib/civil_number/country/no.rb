module CivilNumber
  class No < Country
    def validate
      @error = if !check_by_regexp(REGEXP)
                 'bad number format'
               elsif !birth_date
                 'number birth date is invalid'
               elsif !check_control_digit_1
                 'first control code invalid'
               elsif !check_control_digit_2
                 'second control code invalid'
               end
    end

    def year
      if @parsed_civil_number
        year_value = (@parsed_civil_number[:indv].to_i * 10 + @parsed_civil_number[:gnd].to_i).to_i
        base = case year_value
               when 000..499 then 1900
               when 500..899 then @parsed_civil_number[:year].to_i >= 54 ? 1800 : 2000
               when 900..999 then @parsed_civil_number[:year].to_i >= 40 ? 1900 : 2000
               else
                 0
               end
        @year = base + @parsed_civil_number[:year].to_i
      else
        0
      end
    end

    def day
      @day = @parsed_civil_number[:day].to_i % 40
    end

    private

    MODULUS = 11

    CONTROLCIPHERS_1 = [3, 7, 6, 1, 8, 9, 4, 5, 2].freeze
    CONTROLCIPHERS_2 = [5, 4, 3, 2, 7, 6, 5, 4, 3, 2].freeze

    REGEXP = /^#{SHORT_DATE2_REGEXP}[-+]?(?<indv>\d{2})(?<gnd>\d{1})(?<ctrl>\d{2})$/

    def check_control_digit_1
      ctrl = 11 - calc_sum(digit_number[0, 9], CONTROLCIPHERS_1) % MODULUS
      (ctrl % MODULUS).to_s == @civil_number[-2]
    end

    def check_control_digit_2
      ctrl = 11 - calc_sum(digit_number[0, 10], CONTROLCIPHERS_2) % MODULUS
      (ctrl % MODULUS).to_s == @civil_number[-1]
    end
  end
end
