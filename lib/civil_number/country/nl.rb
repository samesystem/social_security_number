module CivilNumber
    class Nl < Country
      def valid?
        unless check_digits and check_length(CONTROLCIPHERS.size)
          return false
        end
        unless check_control_sum
          @error = 'control sum invalid'
          return false
        end
        true
      end

      private

      MODULUS = 11

      CONTROLCIPHERS = [9, 8, 7, 6, 5, 4, 3, 2, -1].freeze

      def check_control_sum
        sum = calc_sum(@civil_number, CONTROLCIPHERS)
        sum % MODULUS == 0
      end
    end
end
