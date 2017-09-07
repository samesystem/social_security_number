module CivilNumber
    class No < Country
      def valid?
        unless check_digits and check_length(11) and check_date
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

      def gender
        code[8].to_i.odd? ? :male : :female
      end

      def birth_date
        matches = code.match(/^(?<day>\d{2})(?<month>\d{2})(?<year>\d{2})-?(?<individual_number>\d{3})/) or return nil

        year  = matches[:year].to_i
        month = matches[:month].to_i
        day   = matches[:day].to_i

        full_year = base_year(year, matches[:individual_number].to_i) + year

        Date.new(full_year, month, day) if Date.valid_date?(full_year, month, day)
      end

      private

      MODULUS = 11

      CONTROLCIPHERS_1 = [3, 7, 6, 1, 8, 9, 4, 5, 2].freeze
      CONTROLCIPHERS_2 = [5, 4, 3, 2, 7, 6, 5, 4, 3, 2].freeze

      def check_control_digit_1
        ctrl = 11 - calc_sum(code[0, 9], CONTROLCIPHERS_1) % MODULUS
        (ctrl % MODULUS).to_s == code[-2]
      end

      def check_control_digit_2
        ctrl = 11 - calc_sum(code[0, 10], CONTROLCIPHERS_2) % MODULUS
        (ctrl % MODULUS).to_s == code[-1]
      end

      def base_year(year, individual_number)
        case individual_number.to_i
        when 000..499 then 1900 # rubocop:disable Style/NumericLiteralPrefix
        when 500..899 then year >= 54 ? 1800 : 2000
        when 900..999 then year >= 40 ? 1900 : 2000
        end
      end
  end
end
