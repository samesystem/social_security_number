module CivilNumber
    class Lt < Country

      def valid?
        unless check_digits and check_length(11) and birth_date
        end
        unless check_control_sum
          @error = 'control sum invalid'
          return false
        end
        if !@birth_date.nil? and birth_date.to_s != @birth_date
          @error = 'birth date invalid'
          return false
        end
        if !@gender.nil? and gender != @gender
          @error = 'gender invalid'
          return false
        end
        true
      end

      def gender
        code[0].to_i.odd? ? :female : :male
      end

      def birth_date
        matches = @civil_number.match(/^(?<gender>\d{1})(?<year>\d{2})(?<month>\d{2})(?<day>\d{2})-?(?<individual_number>\d{4})/) or return nil

        year  = matches[:year].to_i
        month = matches[:month].to_i
        day   = matches[:day].to_i

        full_year = base_year(year, matches[:gender].to_i) + year

        Date.new(full_year, month, day) if Date.valid_date?(full_year, month, day)
      end

      private

      MODULUS = 11

      CONTROLCIPHERS_1 = [1,2,3,4,5,6,7,8,9,1].freeze
      CONTROLCIPHERS_2 = [3,4,5,6,7,8,9,1,2,3].freeze

      def check_control_sum
        count_last_number == @civil_number[-1, 1].to_i
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

      def base_year(year, gender)
        case gender.to_i
        when 3..4 then 1900
        when 5..6 then 2000
        end
      end
    end
end
