module SocialSecurityNumber
  # SocialSecurityNumber::Lv Latvian Personal Code (Personas kods)
  # https://en.wikipedia.org/wiki/National_identification_number#Latvia
  # https://ec.europa.eu/taxation_customs/tin/pdf/en/TIN_-_country_sheet_LV_en.pdf
  class Lv < Country
    def validate
      @error = 'bad number format' unless validate_formats
    end

    private

    MODULUS = 11

    CONTROLCIPHERS = [10, 5, 8, 4, 2, 1, 6, 3, 7, 9].freeze

    REGEXP_NEW = /^32(?<indv>\d{8})(?<ctrl>\d{1})$/
    REGEXP_OLD = /^#{SHORT_DATE_REGEXP}(?<gnd>\d{1})(?<indv>\d{3})(?<ctrl>\d{1})$/

    def validate_formats
      check_new_format || check_old_format
    end

    def check_new_format
      check_by_regexp(REGEXP_NEW)
    end

    def check_old_format
      check_by_regexp(REGEXP_OLD) && check_date && check_control_sum
    end

    def check_date
      day = @civil_number[0..1]
      month = @civil_number[2..3]
      year = @civil_number[4..6]

      Date.valid_date?(base_year(year).to_i, month.to_i, day.to_i)
    end

    def base_year(year)
      current_year = Time.now.year % 100
      offset_year = year.to_i
      offset_year += 100 if year && offset_year < current_year
      1900 + offset_year
    end

    def check_control_sum
      puts count_last_number
      puts @civil_number[10].to_i
      count_last_number == @civil_number[10].to_i
    end

    def count_last_number
      sum = 1 + calc_sum(@civil_number[0..9], CONTROLCIPHERS)
      sum % MODULUS % 10
    end
  end
end
