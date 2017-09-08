module CivilNumber
  class Dk < Country
    def valid?
      unless check_length(CONTROLCIPHERS.size) and check_date
        return false
      end
      if valid_1968
        return true
      else
        @error = 'control code invalid'
        # go on..
      end
      if valid_2007
        return true
      else
        @error = 'control code invalid, strictly'
        return false
      end
    end

    def gender
      @civil_number[-1].to_i.odd? ? :male : :female
    end

    def birth_date
      matches = @civil_number.match(/^(?<day>\d{2})(?<month>\d{2})(?<year>\d{2})/) or return nil

      full_year = expand_to_full_year(matches[:year].to_i)

      if Date.valid_date?(full_year, matches[:month].to_i, matches[:day].to_i)
        date = Date.new(full_year, matches[:month].to_i, matches[:day].to_i)
      end

      date if date and date.year > 1920
    end

    private

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
      sum = calc_sum(@civil_number, CONTROLCIPHERS)
      sum % MODULUS_1968 == 0
    end

    def valid_2007
      control = @civil_number[6, 4].to_i

      rem_2007 = control % MODULUS_2007

      series = FEMALE_SEEDS[rem_2007] || MALE_SEEDS[rem_2007]

      series.include?(control)
    end

    def expand_to_full_year(year)
      current_year = Time.now.year % 100
      offset_year = year

      offset_year += 100 if year < current_year

      1900 + offset_year
    end
  end
end
