module CivilNumber
  class Country
    require 'date'

    attr_accessor :civil_number, :birth_date, :gender, :individual, :control_number, :error

    def initialize(civil_number)
      @civil_number = self.class.respond_to?(:formatted) ? self.class.formatted(civil_number) : civil_number
      values_from_number if self.class.const_defined?('REGEXP')
    end

    def valid?
      @error = nil
      validate
      @error.nil?
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
      gender = matches[:gender].to_i
puts gender
puts base_year({year: year, gender: gender})
      full_year = base_year({year: year, gender: gender}) + year
      @birth_date = Date.new(full_year, month, day) if Date.valid_date?(full_year, month, day)
      @gender = get_gender(gender)
      @individual = matches[:individual].to_i
      @control_number = matches[:control].to_i
    end

  end
end
