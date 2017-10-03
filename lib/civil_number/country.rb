module CivilNumber
  class Country
    require 'date'

    attr_accessor :civil_number, :birth_date, :gender, :individual, :control_number, :year, :month, :day, :error

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
        sum += digit.to_i * ciphers[i].to_i
      end
      sum
    end

    def check_digits
      unless @civil_number =~ /\A\d+\z/
        return false
      end
      true
    end

    def check_by_regexp(regexp)
      unless @civil_number =~ regexp
        return false
      end
      true
    end

    def check_length(size)
      unless @civil_number.length == size
        return false
      end
      true
    end

    def values_from_number
      matches = @civil_number.match(self.class::REGEXP) or return nil
      @year  = matches[:year].to_i if matches.names.include?('year')

      if matches.names.include?('month')
        @month = self.class.private_instance_methods(false).include?(:get_month) ? get_month(matches[:month]) : matches[:month].to_i
      end

      if matches.names.include?('day')
        @day = self.class.private_instance_methods(false).include?(:get_day) ? get_day(matches[:day].to_i) : matches[:day].to_i
      end

      gender = matches[:gender].to_i if matches.names.include?('gender')
      divider = matches[:divider].to_s if matches.names.include?('divider')

      if @year
        full_year = base_year({year: @year, gender: gender}) + year
      end

      @birth_date = Date.new(full_year, @month, @day) if full_year and Date.valid_date?(full_year, month, day)
      @gender = get_gender(gender) if gender
      @individual = matches[:individual].to_i if matches.names.include?('individual')
      @control_number = matches[:control].to_i if matches.names.include?('control')
    end

  end
end
