module SocialSecurityNumber
  # SocialSecurityNumber::Us validates U.S. (America) Social Security number (SSN) and
  # Individual Taxpayer Identification Number (ITIN), Employer Identification Number (EIN)
  # https://en.wikipedia.org/wiki/National_identification_number#United_States
  # https://www.ssa.gov/employer/verifySSN.htm
  # https://en.wikipedia.org/wiki/Social_Security_number
  # https://en.wikipedia.org/wiki/Individual_Taxpayer_Identification_Number
  class Us < Country
    def validate
      @error = if !validate_formats
                 'bad number format'
               end
    end

    private

    SSN_REGEXP = /^(?<area>\d{3})-(?<group>\d{2})-(?<invidual>\d{4})$/
    ITIN_REGEXP = /^(?<area>\d{3})-(?<group>\d{2})-(?<invidual>\d{4})$/
    EIN_REGEXP = /^(?<area>\d{2})-(?<group>\d{7})$/

    def validate_formats
      (check_by_regexp(SSN_REGEXP) && validate_ssn) ||
      (check_by_regexp(ITIN_REGEXP) && validate_itin) ||
      (check_by_regexp(EIN_REGEXP) && validate_ein)
    end

    def validate_ssn
      matches = @civil_number.match(self.class::SSN_REGEXP) || (return nil)

      if matches[:area] == '000' || matches[:area] == '666' || matches[:group] == '00' ||
         matches[:invidual] == '0000' || matches[:area][0] == '9'
        return false
      else
        return true
      end
    end

    def validate_itin
      matches = @civil_number.match(self.class::ITIN_REGEXP) || (return nil)
      if [70..88].include?(matches[:group].to_i) || matches[:area][0] != '9'
        return false
      else
        return true
      end
    end

    def validate_ein
      matches = @civil_number.match(self.class::EIN_REGEXP) || (return nil)
      matches[:area] =~ /^(0[1-6]||1[0-6]|2[0-7]|[35]\d|[468][0-8]|7[1-7]|9[0-58-9])$/
    end
  end
end
