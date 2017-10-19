module CivilNumber
  class It < Country
    def validate
      @error = if !check_by_regexp(REGEXP)
                 'bad number format'
               elsif !birth_date
                 'number birth date is invalid'
               end
    end

    def month
      months = ['A', 'B', 'C', 'D', 'E', 'H', 'L', 'M', 'P', 'R', 'S', 'T']
      @month = months.index(@parsed_civil_number[:month]).to_i + 1
    end

    def day
      d = @parsed_civil_number[:day].to_i
      @day = d >= 40 ? d - 40 : d
    end

    REGEXP = /^(?<name>[A-Z]{6})-?(?<year>[\dL-V]{2})(?<month>[ABCDEHLMPRST])(?<day>[\dL-V]{2})(?<indv>[A-Z][\dL-V]{3})(?<indv2>[A-Z]{1})$/

  end
end
