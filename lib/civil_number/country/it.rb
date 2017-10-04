module CivilNumber
  class It < Country
    def validate
      @error = if !check_by_regexp(REGEXP)
                 'bad number format'
               elsif !birth_date
                 'number birth date is invalid'
               end
    end

    private

    REGEXP = /^(?<name>[A-Z]{6})-?(?<year>[\dL-V]{2})(?<month>[ABCDEHLMPRST])(?<day>[\dL-V]{2})(?<individual>[A-Z][\dL-V]{3})(?<individual2>[A-Z]{1})$/

    def get_month(month)
      months = ['A', 'B', 'C', 'D', 'E', 'H', 'L', 'M', 'P', 'R', 'S', 'T']
      months.index(month).to_i + 1
    end

    def get_day(day)
      day > 40 ? day - 40 : day
    end

    def base_year(year)
      current_year = Time.now.year % 100
      offset_year = year[:year].to_i
      offset_year += 100 if year[:year] and offset_year < current_year
      1900 + offset_year
    end

  end
end
