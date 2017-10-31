module SocialSecurityNumber
  class Pk < Country
    def validate
      @error = unless check_by_regexp(REGEXP)
                 'bad number format'
               end
    end

    REGEXP = /^(?<location>\d{5})-?(?<family_number>\d{7})-?(?<gnd>\d{1})$/
  end
end
