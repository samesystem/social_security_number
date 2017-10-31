module SocialSecurityNumber
  class Fi < Country
    def validate
      @error = if !check_by_regexp(REGEXP)
                 'bad number format'
               elsif !check_control_simbol
                 'number control sum invalid'
               end
    end

    private

    MODULUS = 31

    CONTROL_REGEXP = /(?<ctrl>[0-9ABCDEFHJKLMNPRSTUVWXY])/
    REGEXP = /^#{SHORT_DATE2_REGEXP}(?<century>[-+A])(?<indv>\d{3})#{CONTROL_REGEXP}$/

    def check_control_simbol
      count_last_simbol.to_s == @control_number.to_s
    end

    def count_last_simbol
      number = "#{@civil_number[0..5]}#{@individual}"
      last_number = number.to_i % MODULUS
      '0123456789ABCDEFHJKLMNPRSTUVWXY'[last_number]
    end
  end
end
