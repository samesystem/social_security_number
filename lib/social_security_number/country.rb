module SocialSecurityNumber
  # SocialSecurityNumber::Country
  class Country
    require 'date'

    attr_accessor :civil_number, :birth_date, :individual,
                  :control_number, :error

    DATE_REGEXP = /(?<year>\d{4})(?<month>\d{2})(?<day>\d{2})/
    SHORT_DATE2_REGEXP = /(?<day>\d{2})(?<month>\d{2})(?<year>\d{2})/
    SHORT_DATE_REGEXP = /(?<year>\d{2})(?<month>\d{2})(?<day>\d{2})/

    def initialize(civil_number)
      @civil_number = civil_number.to_s.upcase
      values_from_number if self.class.const_defined?('REGEXP')
    end

    def valid?
      @error = nil
      validate
      @error.nil?
    end

    def parsed_civil_number
      @parsed_civil_number ||= @civil_number.match(self.class::REGEXP)
    end

    def digit_number
      @civil_number.gsub(/[^\d]/, '')
    end

    def gender
      return unless @parsed_civil_number.names.include?('gnd')
      @gender ||= @parsed_civil_number[:gnd].to_i.odd? ? :male : :female
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

    def year
      return unless @parsed_civil_number.names.include?('year')
      current_year = Time.now.year % 100
      offset_year = @parsed_civil_number[:year].to_i
      offset_year += 100 if offset_year && offset_year < current_year
      @year ||= 1900 + offset_year.to_i
    end

    def month
      @month ||= value_from_parsed_civil_number('month').to_i
    end

    def day
      @day ||= value_from_parsed_civil_number('day').to_i
    end

    def date
      year
      month
      day
      return unless @year && @month && @day &&
                    Date.valid_date?(@year, @month, @day)
      @birth_date = Date.new(@year, @month, @day)
    end

    def value_from_parsed_civil_number(key)
      return unless @parsed_civil_number.names.include?(key)
      @parsed_civil_number[key.to_sym].to_s
    end

    def values_from_number
      parsed_civil_number
      return unless @parsed_civil_number
      @individual = value_from_parsed_civil_number('indv')
      @control_number = value_from_parsed_civil_number('ctrl')
      gender
      date
    end
  end
end
