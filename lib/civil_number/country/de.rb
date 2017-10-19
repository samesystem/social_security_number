module CivilNumber
  class De < Country
    def validate
      @error = if !check_digits
                 'it is not number'
               elsif !check_length(11)
                 'number shuld be length of 11'
               elsif @civil_number[0].to_i.zero?
                 'first number is invalid'
               # elsif !check_digits_apperings
               #   'first number is invalid'
               elsif !check_control_sum
                 'number control sum invalid'
               end
    end

    private

    def check_control_sum
      count_last_number == @civil_number[10].to_i
    end

    def count_last_number
      sum = 0
      product = 10

      digits(@civil_number.to_s[0..9]).each_with_index do |digit, _i|
        sum = (digit.to_i + product) % 10
        sum = 10 if sum.zero?
        product = (sum * 2) % 11
      end
      checksum = 11 - product
      checksum = 0 if checksum == 10
      checksum
    end

    def group_number(number)
      out = []
      digits(number).group_by(&:itself).map { |k, v| out[k.to_i] = v.count }
      out
    end

    def digits(number)
      number.split(//)
    end

    def check_digits_apperings
      out = true

      if validate_2015
        out = false
      elsif validate_2016
        out = false
      end
      out
    end

    def count_dig(digits, number)
      (digits.select { |count| count.to_i == number }).count
    end

    def validate_2015
      # validate ids that are only valid since 2015
      # one digit appears exactly twice and all other digits appear exactly once
      digit = group_number(@civil_number.to_s[0..9]).compact
      count_dig(digit, 2) != 1 && count_dig(digit, 1) != 8
    end

    def validate_2016
      # validate ids that are only valid since 2016
      # two digits appear zero times and one digit appears exactly three times
      # and all other digits appear exactly once
      digit = group_number(@civil_number.to_s[0..9]).compact
      count_dig(digit, 2).zero? && count_dig(digit, 3) != 1 &&
        count_dig(digit, 1) != 7
    end
  end
end
