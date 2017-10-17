module CivilNumber
    class Fr < Country
      def validate
        @error = if !check_by_regexp(REGEXP)
                   'bad number format'
                 elsif !check_control_sum
                   'number control sum invalid'
        end
      end

      private

      REGEXP = /^(?<gender>\d{1})(?<year>\d{2})(?<month>\d{2})(?<department1>\d{1})(?<department2>[0-9AB]{1})(?<place>\d{3})(?<individual>\d{3})(?<control>\d{2})$/

      def check_control_sum
        count_last_number == @control_number.to_i
      end

      def count_last_number
        number = @civil_number[0..12]
        department = @civil_number[5..6]
        if department == '2A'
          number = ("#{@civil_number[0..4]}19#{@civil_number[7..12]}")
        elsif department == '2B'
          number = ("#{@civil_number[0..4]}18#{@civil_number[7..12]}")
        end
        97 - (number.to_i % 97)
      end

      def base_year(year)
        current_year = Time.now.year % 100
        offset_year = year[:year].to_i
        offset_year += 100 if year[:year] and offset_year < current_year
        1900 + offset_year
      end

      def get_gender(code)
        code.to_i.odd? ? :male : :female
      end
    end
end
