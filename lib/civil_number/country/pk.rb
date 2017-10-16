module CivilNumber
    class Pk < Country

      def validate
        @error = if !check_by_regexp(REGEXP)
          'bad number format'
        end
      end

      private

      REGEXP = /^(?<location>\d{5})-?(?<family_number>\d{7})-?(?<gender>\d{1})$/

      def get_gender(code)
        code.to_i.odd? ? :male : :female
      end
    end
end
