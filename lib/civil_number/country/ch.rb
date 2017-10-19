module CivilNumber
  class Ch < Country
    # https://en.wikipedia.org/wiki/National_identification_number#Switzerland
    # https://de.wikipedia.org/wiki/Sozialversicherungsnummer#Versichertennummer
    # http://www.sozialversicherungsnummer.ch/aufbau-neu.htm
    def validate
      @error = if !check_by_regexp(REGEXP)
                 'bad number format'
               elsif !check_control_sum
                 'number control sum invalid'
               end
    end

    private

    MODULUS = 10

    CONTROLCIPHERS = [1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3].freeze

    INV_REGEXP = /(?<indv1>\d{4})[.]?(?<indv2>\d{4})[.]?(?<indv3>\d{1})/
    REGEXP = /^(?<adress>756)[.]?#{INV_REGEXP}(?<control>\d{1})$/

    def check_control_sum
      count_last_number.to_i == @control_number.to_i
    end

    def count_last_number
      sum = calc_sum(digit_number[0..11], CONTROLCIPHERS)
      modus = sum % MODULUS
      modus > 0 ? 10 - modus : modus
    end
  end
end
