module CivilNumber
    class No < Country
      def valid?
        unless check_by_regexp(REGEXP) and check_date
          return false
        end
        unless check_control_digit_1
          @error = 'first control code invalid'
          return false
        end
        unless check_control_digit_2
          @error = 'second control code invalid'
          return false
        end
        true
      end

      private

      MODULUS = 11

      CONTROLCIPHERS_1 = [3, 7, 6, 1, 8, 9, 4, 5, 2].freeze
      CONTROLCIPHERS_2 = [5, 4, 3, 2, 7, 6, 5, 4, 3, 2].freeze

      REGEXP = /^(?<day>\d{2})(?<month>\d{2})(?<year>\d{2})-?(?<individual>\d{2})(?<gender>\d{1})(?<control>\d{2})$/

      def check_control_digit_1
        ctrl = 11 - calc_sum(number[0, 9], CONTROLCIPHERS_1) % MODULUS
        (ctrl % MODULUS).to_s == @control_number[-2]
      end

      def check_control_digit_2
        ctrl = 11 - calc_sum(number[0, 10], CONTROLCIPHERS_2) % MODULUS
        (ctrl % MODULUS).to_s == @control_number[-1]
      end

      def base_year(year)
        case (year[:individual_number].to_i*10+year[:gender]).to_i
        when 000..499 then 1900
        when 500..899 then year[:year] >= 54 ? 1800 : 2000
        when 900..999 then year[:year] >= 40 ? 1900 : 2000
        end
      end

      def get_gender(code)
        code.odd? ? :male : :female
      end

      def formatted(string)
        val = string.to_s.gsub(/\D/, '')

        return val if val.length < 11
        val.insert(val.length - 5, "-")
      end

      def number
        @civil_number.to_s.gsub(/\D/, '')
      end
  end
end
