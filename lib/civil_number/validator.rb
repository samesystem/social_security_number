module CivilNumber
  class Validator
    SUPPORTED_COUNTRY_CODES = %w[DK LT NL NO SE].freeze

    attr_accessor :civil_number, :country_code, :error

    def initialize(civil_number, country_code, birth_date = nil, gender = nil)
      @civil_number = civil_number.to_s.strip.gsub(/\s+/, '').upcase
      @country_code = country_code.to_s.strip.gsub(/\s+/, '').upcase

      @birth_date = birth_date
      @gender = gender

      unless self.class::SUPPORTED_COUNTRY_CODES.include?(@country_code)
        raise "Unexpected country code '#{country_code}' that is not yet supported"
      end
    end

    def valid?
      civil_number = CivilNumber.const_get(@country_code.capitalize).new(@civil_number)

      if civil_number.valid?
        if !@birth_date.nil? and civil_number.birth_date.to_s != @birth_date
          @error = "birth date #{@birth_date} dont match #{civil_number.birth_date}"
          return false
        end
        if !@gender.nil? and civil_number.gender != @gender
          @error = 'gender #{@gender} dont match #{civil_number.gender}'
          return false
        end
        return true
      end
      @error = civil_number.error
      false
    end

    private

    def validate_birth_date
      if !@birth_date.nil? and @birth_date.class != Date
        raise 'birth_date'
      end
    end
  end
end
