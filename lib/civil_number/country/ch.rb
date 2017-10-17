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

    CONTROLCIPHERS = [1,3,1,3,1,3,1,3,1,3,1,3].freeze

    REGEXP = /^(?<adress>756)[.]?(?<individual1>\d{4})[.]?(?<individual2>\d{4})[.]?(?<individual3>\d{1})(?<control>\d{1})$/

    def check_control_sum
      count_last_number.to_i == @control_number.to_i
    end

    def count_last_number
      sum = calc_sum(number[0..11], CONTROLCIPHERS)
      modus = sum % MODULUS
      modus > 0 ? 10 - modus : modus
    end

    def number
      @civil_number.gsub('.', '')
    end
  end
end
