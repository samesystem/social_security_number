# frozen_string_literal: true

module SocialSecurityNumber
  # SocialSecurityNumber::De validates Germany RVNR
  class De2 < Country
    VALID_AREA_NUMBERS = %w[
      02 03 04 08 09 10 11 12 13 14 15 16 17 18 19 20 21 23 24 25 26 28 29
      42 43 44 48 49 50 51 52 53 54 55 56 57 58 59 60 61 63 64 65 66 68 69
      38 39 80 81 82 89
    ].freeze

    FACTORS = [2, 1, 2, 5, 7, 1, 2, 1, 2, 1, 2, 1].freeze

    def validate
      @error = if !check_length(12)
                 'number should be length of 12'
               elsif !valid_area_number?
                 'invalid area number'
               elsif !valid_birth_date?
                 'invalid date of birth'
               elsif !valid_initial?
                 'Invalid letter'
               elsif !valid_serial_number?
                 'invalid serial number'
               elsif !check_control_sum
                 'number control sum invalid'
               end
    end

    private

    def valid_area_number?
      VALID_AREA_NUMBERS.include?(@civil_number[0..1])
    end

    def valid_birth_date?
      day = @civil_number[2..3].to_i
      month = @civil_number[4..5].to_i
      year = @civil_number[6..7].to_i
      (1..31).cover?(day) && (1..12).cover?(month) && (0..99).cover?(year)
    end

    def valid_initial?
      @civil_number[8].match?(/^[A-Z]$/)
    end

    def valid_serial_number?
      @civil_number[9..10].to_i.between?(0, 99)
    end

    def check_control_sum
      letter_position = @civil_number[8].ord - 'A'.ord + 1
      modified_number = @civil_number[0..7] +
                        letter_position.to_s.rjust(2, '0') +
                        @civil_number[9..10]

      calculate_check_sum(modified_number) % 10 == @civil_number[11].to_i
    end

    def calculate_check_sum(modified_number)
      sum = 0
      modified_number.chars.each_with_index do |char, index|
        product = char.to_i * FACTORS[index]
        sum += product.digits.sum
      end
      sum
    end
  end
end
