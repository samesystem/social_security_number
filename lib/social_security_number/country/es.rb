module SocialSecurityNumber
    # SocialSecurityNumber::Es validates Spain National Identity Document (Documento Nacional de Identidad (DNI)) number
    # and NIE Number (Número de Identificación de Extranjeros, Foreigner's Identification Number)
    # The NIE is an identification number for foreigners. It is a 9 digit number
    # where the first digit is either X, Y or Z and last digit is a checksum letter.
    # The DNI is a 9 digit number used to identify Spanish citizens. The last digit is a checksum letter.
    # https://en.wikipedia.org/wiki/National_identification_number#Spain
    class Es < Country
      def validate
        @error = if !validate_formats
                   'bad number format'
                 elsif !dni_validation && !nie_validation
                   'bad DNI, NIE number'
                 end
      end

      private

      DNI_REGEXP = /^(?<individual>\d{8})[- ]?(?<ctrl>[A-Z])$/
      NIE_REGEXP = /^(?<first_letter>[XYZ])[- ]?(?<individual>\d{7})[- ]?(?<ctrl>[A-Z])$/

      def validate_formats
        check_by_regexp(DNI_REGEXP) || check_by_regexp(NIE_REGEXP)
      end

      def dni_validation
        count_last_simbol(@civil_number[0..7]) == @civil_number[-1]
      end

      def nie_validation
        remap = %W[X Y Z]
        number = "#{remap.index(@civil_number[0])}#{@civil_number[1..7]}"
        count_last_simbol(number) == @civil_number[-1]
      end

      def count_last_simbol(number)
        letters = "TRWAGMYFPDXBNJZSQVHLCKE"
        letters[number.to_i % 23].chr
      end
    end
end
