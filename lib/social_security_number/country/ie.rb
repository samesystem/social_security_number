module SocialSecurityNumber
  # SocialSecurityNumber::Ie validates Ireland Personal Public Service Number (PPS No)
  # https://en.wikipedia.org/wiki/Personal_Public_Service_Number
  # http://www.welfare.ie/en/Pages/Extension-of-the-Personal-Public-Service-Number-Range.aspx
  class Ie < Country
    def validate
      @error = if !check_by_regexp(REGEXP)
                 'bad number format'
               elsif !check_control_simbol
                 'number control sum invalid'
               end
    end

    private

    MODULUS = 23

    CONTROLCIPHERS = [8, 7, 6, 5, 4, 3, 2].freeze

    REGEXP = /^(?<indv>\d{7})[- .]?(?<ctrl>[A-W])[AHWTX]?$/

    def check_control_simbol
      count_last_simbol.to_s == @control_number.to_s
    end

    def count_last_simbol
      sum = calc_sum(@individual, CONTROLCIPHERS)
      alfabet = %w[W A B C D E F G H I J K L M N O P Q R S U V]
      value = if @civil_number[-1] != @control_number.to_s
                alfabet.index(@civil_number[-1]).to_i
              else
                0
              end
      last_simbol = (sum + (value * 9)) % MODULUS
      'WABCDEFGHIJKLMNOPQRSTUV'[last_simbol]
    end
  end
end
