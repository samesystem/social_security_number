module CivilNumber
  class Country
    require 'date'
    require "civil_number/country/dk"
    require "civil_number/country/lt"
    require "civil_number/country/nl"
    require "civil_number/country/no"
    require "civil_number/country/se"

    attr_accessor :civil_number, :birth_date, :gender, :individual, :control_number, :error

    def initialize(civil_number)
      @civil_number = formatted(civil_number)
      values_from_number if self.class::REGEXP
    end

    private

    def calc_sum(number, ciphers)
      digits = number.split(//)

      sum = 0
      digits.each_with_index do |digit, i|
        sum += digit.to_i * ciphers[i]
      end
      sum
    end

    def check_digits
      unless @civil_number =~ /\A\d+\z/
        @error = 'non digits present'
        return false
      end
      true
    end

    def check_by_regexp(regexp)
      unless @civil_number =~ regexp
        @error = 'format validation'
        return false
      end
      true
    end

    def check_length(size)
      unless @civil_number.length == size
        @error = 'code length invalid'
        return false
      end
      true
    end

    # checks format: ddmmyy
    def check_date
      unless @civil_number =~ /\A(\d\d)(\d\d)(\d\d)/
        @error = 'date format invalid'
        return false
      end
      unless Date.valid_civil?($3.to_i, $2.to_i, $1.to_i)
        @error = 'date invalid'
        return false
      end
      true
    end

    def values_from_number
      matches = @civil_number.match(self.class::REGEXP) or return nil

      year  = matches[:year].to_i
      month = matches[:month].to_i
      day   = matches[:day].to_i

      full_year = base_year({year:year}) + year
      @birth_date = Date.new(full_year, month, day) if Date.valid_date?(full_year, month, day)
      @gender = matches[:gender].to_i
      @individual = matches[:individual].to_i
      @control_number = matches[:control].to_i
    end

  end
end
