module CivilNumber
  module Country
    require 'date'
    require "civil_number/country/lt"

    class << self
    attr_reader :civil_number, :country_code, :error
    end

    SUPPORTED_COUNTRY_CODES = %w(LT NO)

    def initialize(civil_number, country_code)
      @civil_number = civil_number.to_s.strip.gsub(/\s+/, '').upcase
      @country_code = country_code.to_s.strip.gsub(/\s+/, '').upcase
      unless self.class::SUPPORTED_COUNTRY_CODES.include?(@country_code)
        raise RuntimeError.new("Unexpected country code '#{country_code}' that is not yet supported")
      end
    end

    def valid?
      return false if @civil_number.blank?
      "CivilNumber::Country::#{@country_code.titleize}".constantize.valid?(@civil_number)
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
      unless code =~ /\A\d+\z/
        @error = 'non digits present'
        return false
      end
      true
    end

    def check_length(size)
      unless code.length == size
        @error = 'code length invalid'
        return false
      end
      true
    end

    # checks format: ddmmyy
    def check_date
      unless code =~ /\A(\d\d)(\d\d)(\d\d)/
        @error = 'date format invalid'
        return false
      end
      unless Date.valid_civil?($3.to_i, $2.to_i, $1.to_i)
        @error = 'date invalid'
        return false
      end
      true
    end

  end
end
