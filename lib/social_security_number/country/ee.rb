module SocialSecurityNumber
  # SocialSecurityNumber::Ee validates Estonian Personal ID numbers (isikukood (IK))
  # https://en.wikipedia.org/wiki/National_identification_number#Estonia
  # https://et.wikipedia.org/wiki/Isikukood
  class Ee < Country
    def validate
      @error = if !check_digits
                 'it is not number'
               elsif !check_length(11)
                 'number should be length of 11'
               elsif @parsed_civil_number[:gnd].to_i > 8
                 'gender number is not recognized'
               elsif !birth_date
                 'number birth date is invalid'
               elsif !check_control_sum
                 'number control sum invalid'
               end
    end

    def year
      if @parsed_civil_number
        base = case @parsed_civil_number[:gnd].to_i
               when 1..2 then 1800
               when 3..4 then 1900
               when 5..6 then 2000
               when 7..8 then 2100
               else
                 0
               end
        @year = base + @parsed_civil_number[:year].to_i
      else
        0
      end
    end

    private

    MODULUS = 11

    CONTROLCIPHERS = [1, 2, 3, 4, 5, 6, 7, 8, 9, 1].freeze

    REGEXP = /^(?<gnd>\d{1})#{SHORT_DATE_REGEXP}-?(?<indv>\d{3})(?<ctrl>\d{1})$/

    def check_control_sum
      count_last_number == @control_number.to_i
    end

    def count_last_number
      sum = calc_sum(@civil_number[0..9], CONTROLCIPHERS)
      last_number = sum % MODULUS
      return last_number unless last_number == 10
      sum = calc_sum(@civil_number[0..9], CONTROLCIPHERS2)
      last_number = sum % MODULUS
      last_number == 10 ? 0 : last_number
    end
  end
end
