module CivilNumber
    class Mx < Country
    # https://es.stackoverflow.com/questions/31039/c%C3%B3mo-validar-una-curp-de-m%C3%A9xico
    # https://en.wikipedia.org/wiki/Unique_Population_Registry_Code
    # https://es.wikipedia.org/wiki/Registro_Federal_de_Contribuyentes_(M%C3%A9xico)
      def validate
        @error = if !check_by_regexp(REGEXP)
          'bad number format'
        elsif !birth_date
          'number birth date is invalid'
        elsif !check_control_sum
          'number control sum invalid'
        end
      end

      private

      MODULUS = 10

      LINIT = /(?<linit>[A-Z])/ # the first character is the initial of the first last name
      LINIT_2 = /(?<linit2>[A-Z]{2})/ # the initials of the second last name and the name
      FIC = /(?<fic>[B-DF-HJ-NP-TV-Z]{3})/ # the first internal consonants of surnames and names
      FEDERAL = /(?<federal>(AS|BC|BS|CC|CS|CH|CL|CM|DF|DG|GT|GR|HG|JC|MC|MN|MS|NT|NL|OC|PL|QT|QR|SP|SL|SR|TC|TS|TL|VZ|YN|ZS|NE))/

      REGEXP = /^#{LINIT}(?<surname>[AEIOUX])#{LINIT_2}[ .-]?(?<year>\d{2})(?<month>\d{2})(?<day>\d{2})[ .-]?(?<gender>[HM]{1})[ .-]?#{FEDERAL}[ .-]?#{FIC}[ .-]?(?<homoclave>[A-Z\d])[ .-]?(?<control>\d{1})$/

      def check_control_sum
        count_last_number.to_i == @control_number.to_i
      end

      def count_last_number
        n = number
        alfabet = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I',
          'J','K','L','M','N','Ñ','O','P','Q','R','S','T','U','V','W','X','Y','Z']
        sum = 0
        17.times do |i|
          sum += alfabet.index(n[i]).to_i * (18 - i)
        end

        last_number = 10 - sum % MODULUS

        last_number == 10 ? 0 : last_number
      end

      def base_year(year)
        current_year = Time.now.year % 100
        offset_year = year[:year].to_i
        offset_year += 100 if year[:year] and offset_year < current_year
        1900 + offset_year
      end

      def get_gender(code)
        code.to_s == 'H' ? :male : :female
      end

      def number
        @civil_number.gsub(' |.|-', '')
      end
    end
end
