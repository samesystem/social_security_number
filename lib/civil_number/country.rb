module CivilNumber
  class Country
    require 'date'

    attr_accessor :civil_number, :birth_date, :gender, :individual, :control_number, :year, :month, :day, :error

    def initialize(civil_number)
      @civil_number = self.class.respond_to?(:formatted) ? self.class.formatted(civil_number) : civil_number.to_s.upcase
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
      return false unless @civil_number =~ /\A\d+\z/
      true
    end

    def check_by_regexp(regexp)
      return false unless @civil_number =~ regexp
      true
    end

    def check_length(size)
      return false unless @civil_number.length == size
      true
    end

    def values_from_number
      (matches = @civil_number.match(self.class::REGEXP)) || (return nil)

      if matches.names.include?('month')
        @month = self.class.private_instance_methods(false).include?(:get_month) ? get_month(matches[:month]) : matches[:month].to_i
      end

      if matches.names.include?('day')
        @day = self.class.private_instance_methods(false).include?(:get_day) ? get_day(matches[:day].to_i) : matches[:day].to_i
      end

      divider = matches[:divider].to_s if matches.names.include?('divider')


      @individual = matches[:individual].to_s if matches.names.include?('individual')
      @control_number = matches[:control].to_s if matches.names.include?('control')

      gender = matches[:gender].to_i if matches.names.include?('gender')

      @gender = if matches.names.include?('gender')
                  get_gender(gender)
                else
                  gender_from_number if self.class.private_instance_methods(false).include?(:gender_from_number)
                end
      if matches.names.include?('year')
        @year = base_year(year: matches[:year], gender: gender)
      end
      @birth_date = Date.new(@year, @month, @day) if @year && @month && @day && Date.valid_date?(@year, @month, @day)
    end
  end
end
