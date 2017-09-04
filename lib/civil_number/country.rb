module CivilNumber
  class Country
    attr_reader :civil_number, :country_code, :error

    SUPPORTED_COUNTRY_CODES = %w(LT)

    def initialize(civil_number, country_code)
      @civil_number = civil_number.to_s.strip.gsub(/\s+/, '').upcase
      @country_code = country_code.to_s.strip.gsub(/\s+/, '').upcase
      unless self.class::SUPPORTED_COUNTRY_CODES.include?(@country_code)
        raise RuntimeError.new("Unexpected country code '#{country_code}' that is not yet supported")
      end
    end

    def valid?
      return false if @civil_number.blank?
      "CivilNumber::Country::#{@country_code.titleize}".constantize.send(@civil_number)
    end
  end
end
