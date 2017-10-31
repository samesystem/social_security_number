module SocialSecurityNumber
  # SocialSecurityNumber::Cn validates Chinese Resident Identity Card Number
  # https://en.wikipedia.org/wiki/Resident_Identity_Card#Identity_card_number
  class Cn < Country
    def validate
      @error = if !check_digits
                 'it is not number'
               elsif !check_by_regexp(REGEXP)
                 'bad number format'
               elsif !birth_date
                 'number birth date is invalid'
               elsif !check_control_sum
                 'number control sum invalid'
               end
    end

    def year
      @year = @parsed_civil_number[:year].to_i
    end

    def gender
      @gender = @individual.to_i.odd? ? :male : :female
    end

    private

    MODULUS = 11

    CONTROLCIPHERS = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1].freeze

    DATE_REGEXP = /(?<year>\d{4})[- .]?(?<month>\d{2})[- .]?(?<day>\d{2})/
    REGEXP = /^(?<adr>\d{6})[- .]?#{DATE_REGEXP}[- .]?(?<indv>\d{3})[- .]?(?<ctrl>\d{1})$/

    def check_control_sum
      count_last_number.to_i == @control_number.to_i
    end

    def count_last_number
      (12 - (calc_sum(@civil_number[0..16], CONTROLCIPHERS) % MODULUS)) % MODULUS
    end
  end
end
