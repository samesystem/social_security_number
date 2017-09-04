module CivilNumber
  module Country
    class No
      def valid?
      #  unless check_digits and check_length(CONTROLCIPHERS.size)
      #    return false
      #  end
      #  unless check_control_sum
      #    @error = 'control sum invalid'
      #    return false
      #  end
        false
      end

      def gender
        code[0].to_i.odd? ? :female : :male
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

      CONTROLCIPHERS = [9, 8, 7, 6, 5, 4, 3, 2, -1].freeze

      def check_control_sum
        sum = calc_sum(code, CONTROLCIPHERS)
        sum % MODULUS == 0
      end
    end
  end
end
