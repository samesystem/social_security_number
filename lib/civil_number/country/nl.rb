module CivilNumber
    class Nl < Country
      def validate
        @error = if !check_digits
          'it is not number'
        elsif !check_length(CONTROLCIPHERS.size)
          'number shuld be length of 9 or 8'
        elsif !check_control_sum
          'number control sum invalid'
        end
      end

      private

      MODULUS = 11

      CONTROLCIPHERS = [9, 8, 7, 6, 5, 4, 3, 2, -1].freeze

      def check_control_sum
        sum = calc_sum(@civil_number, CONTROLCIPHERS)
        sum % MODULUS == 0
      end

      def formatted(civil_number)
       civil_number.length == 8 ? "0#{civil_number}" : civil_number
      end
    end
end
