module SocialSecurityNumber
  # SocialSecurityNumber::Validator
  class Validator
    SUPPORTED_COUNTRY_CODES = %w[BE CA CH CN CZ DE DK ES FI FR GB IE
                                 IS IT LT MX NL NO PK SE US].freeze

    attr_accessor :civil_number, :country_code, :error

    def initialize(params = {})
      @civil_number = params[:number].to_s.strip.gsub(/\s+/, '').upcase
      @country_code = params[:country_code].to_s.strip.gsub(/\s+/, '').upcase

      @birth_date = params[:birth_date] ? params[:birth_date] : nil
      @gender = params[:gender] ? params[:gender] : nil

      unless self.class::SUPPORTED_COUNTRY_CODES.include?(@country_code)
        raise "Unexpected country code '#{country_code}' that is not yet supported"
      end
    end

    def valid?
      civil_number = SocialSecurityNumber.const_get(@country_code.capitalize).new(@civil_number)

      if civil_number.valid?
        if !@birth_date.nil? && !civil_number.birth_date.nil? && civil_number.birth_date.to_s != @birth_date.to_s
          @error = "birth date #{@birth_date} dont match #{civil_number.birth_date}"
          return false
        end
        if !@gender.nil? && !civil_number.gender.nil? && civil_number.gender.to_s.strip != @gender.to_s.strip
          @error = "gender #{@gender} dont match #{civil_number.gender}"
          return false
        end
        return true
      end
      @error = civil_number.error
      false
    end

  end
end
