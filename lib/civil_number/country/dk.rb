module CivilNumber
  class Dk < Country

    def validate
      @error = if !check_by_regexp(REGEXP)
        'bad number format'
      elsif @birth_date.nil?
        'number birth date is invalid'
      elsif !valid_1968
        'first control code invalid'
      elsif !valid_2007
        'second control code invalid'
      end
    end

    private

    REGEXP = /^(?<day>\d{2})(?<month>\d{2})(?<year>\d{2})(?<divider>[\-]{0,1})(?<individual>\d{3})(?<gender>\d{1})$/

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

    # main validation
    def valid_1968
      sum = calc_sum(number, CONTROLCIPHERS)
      sum % MODULUS_1968 == 0
    end

    def valid_2007
      control = number[6, 4].to_i
      rem_2007 = control % MODULUS_2007
      series = FEMALE_SEEDS[rem_2007] || MALE_SEEDS[rem_2007]
      series.include?(control)
    end

    def base_year(year)
      current_year = Time.now.year % 100
      offset_year = year[:year].to_i
      offset_year += 100 if year[:year] and offset_year < current_year
      1900 + offset_year.to_i
    end

    def get_gender(code)
      code.odd? ? :male : :female
    end

    def number
      @civil_number.to_s.gsub(/\D/, '')
    end
  end
end
