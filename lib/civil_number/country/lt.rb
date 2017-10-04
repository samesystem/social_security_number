module CivilNumber
    class Lt < Country

      def validate
        @error = if !check_digits
          'it is not number'
        elsif !check_length(11)
          'number shuld be length of 11'
        elsif gender_number > 6
          'gender number is not recognaized'
        elsif !birth_date
          'number birth date is invalid'
        elsif !check_control_sum
          'number control sum invalid'
        end
      end

      private

      MODULUS = 11

      CONTROLCIPHERS_1 = [1,2,3,4,5,6,7,8,9,1].freeze
      CONTROLCIPHERS_2 = [3,4,5,6,7,8,9,1,2,3].freeze

      REGEXP = /^(?<gender>\d{1})(?<year>\d{2})(?<month>\d{2})(?<day>\d{2})-?(?<individual>\d{3})(?<control>\d{1})$/

      def check_control_sum
        count_last_number == @control_number
      end

      def count_last_number
        sum = calc_sum(@civil_number[0..9], CONTROLCIPHERS_1)
        last_number = sum % MODULUS
        if last_number < 10
          return last_number
        else
          sum = calc_sum(@civil_number[0..9], CONTROLCIPHERS_2)
          last_number = sum % MODULUS
          if last_number < 10
            return last_number
          end
        end
        return 0
      end

      def base_year(year)
        base = case year[:gender].to_i
        when 1..2 then 1800
        when 3..4 then 1900
        when 5..6 then 2000
        else
          0
        end
        base + year[:year].to_i
      end

      def get_gender(code)
        code.odd? ? :male : :female
      end

      def gender_number
        @civil_number.to_s[0].to_i
      end

    end
end
