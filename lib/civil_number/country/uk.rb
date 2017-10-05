module CivilNumber
    class Uk < Country

      def validate
        @error = if !validate_formats
                   'bad number format'
                 elsif check_length(10) && !(nhs_validation || chi_validation)
                   'bad nhs or chi number'
                 end
      end

      private

      NINO_REGEXP = /^(?<first_letter>[A-CEGHJ-PRSTW-Z])[- ]?(?<second_letter>[A-CEGHJ-NPRSTW-Z])[- ]?(?<first_numbers>\d{2})[- ]?(?<second_numbers>\d{2})[- ]?(?<last_numbers>\d{2})[- ]?(?<last_simbols>[A-D\s])$/
      NHS_REGEXP = /^(?<first_number>[0-9]{3})[- ]?(?<second_number>[0-9]{3})[- ]?(?<last_number>[0-9]{4})$/
      CHI_REGEXP = /^(?<day>\d{2})(?<month>\d{2})(?<year>\d{2})[- ]?(?<last_number>[0-9]{4})$/

      def validate_formats
        check_nino_format || check_by_regexp(NHS_REGEXP) || check_by_regexp(CHI_REGEXP)
      end

      def check_nino_format
        check_by_regexp(NINO_REGEXP) && !check_by_regexp(/^(GB|BG|NK|KN|TN|NT|ZZ)/)
      end

      def nhs_validation
        check_control_sum
      end

      def chi_validation
        check_date
      end

      def check_date
        day = @civil_number[0..1]
        month = @civil_number[2..3]
        year = @civil_number[4..6]

        Date.valid_date?(base_year(year).to_i, month.to_i, day.to_i)
      end

      def base_year(year)
        current_year = Time.now.year % 100
        offset_year = year.to_i
        offset_year += 100 if year and offset_year < current_year
        1900 + offset_year
      end

      def check_control_sum
        count_last_number == @civil_number[9].to_i
      end

      def count_last_number
        result_array = []
        9.times do |i|
          result_array << ((11 - (i + 1)) * @civil_number[i].to_i)
        end
        if (11 - (result_array.inject(:+) % 11)) == 10
          return false
        else
          return 0 if result_array.inject(:+) % 11 == 0
          return 11 - (result_array.inject(:+) % 11)
        end
      end
    end
end
