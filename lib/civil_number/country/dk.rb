module CivilNumber
  class Dk < Country
    def validate
      @error = if !check_by_regexp(REGEXP)
                 'bad number format'
               elsif !birth_date
                 'number birth date is invalid'
               elsif !valid_1968 && !valid_2007
                 'control code invalid'
               end
    end

    private

    REGEXP = /^#{SHORT_DATE2_REGEXP}(?<divider>[\-]{0,1})(?<indv>\d{3})(?<gnd>\d{1})$/

    MODULUS_1968 = 11
    MODULUS_2007 = 6

    CONTROLCIPHERS = [4, 3, 2, 7, 6, 5, 4, 3, 2, 1].freeze

    FEMALE_SEEDS = {
      4 => 10..9994,
      2 =>  8..9998,
      0 => 12..9996
    }.freeze

    MALE_SEEDS = {
      1 =>  7..9997,
      3 =>  9..9999,
      5 => 11..9995
    }.freeze

    def valid_1968
      sum = calc_sum(digit_number, CONTROLCIPHERS)
      (sum % MODULUS_1968).zero?
    end

    def valid_2007
      control = digit_number[6, 4].to_i
      rem2007 = control % MODULUS_2007
      series = FEMALE_SEEDS[rem2007] || MALE_SEEDS[rem2007]
      series.include?(control)
    end
  end
end
