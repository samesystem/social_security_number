module SocialSecurityNumber
  # SocialSecurityNumber::Pk validates Pakistan computerised national identity card number (CNIC)
  # https://en.wikipedia.org/wiki/National_identification_number#Pakistan
  # https://www.geo.tv/latest/157233-secret-behind-every-digit-of-the-cnic-number
  class Pk < Country
    def validate
      @error = unless check_by_regexp(REGEXP)
                 'bad number format'
               end
    end

    REGEXP = /^(?<location>\d{5})-?(?<family_number>\d{7})-?(?<gnd>\d{1})$/
  end
end
