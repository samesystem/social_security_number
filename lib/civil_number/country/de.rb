module CivilNumber
  class De < Country
    def validate
      @error = if !check_digits
                 'it is not number'
               elsif !check_length(11)
                 'number shuld be length of 11'
               elsif @civil_number[0].to_i == 0
                 'first number is invalid'
               #elsif !check_digits_apperings
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
        sum = 10 if sum == 0
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
      digits = group_number(@civil_number.to_s[0..9]).compact
      out = true
      # validate ids that are only valid since 2015
      # one digit appears exactly twice and all other digits appear exactly once
      if (digits.select { |count| count.to_i == 2 }).count != 1 && (digits.select { |count| count.to_i == 1 }).count != 8
        out = false
      # validate ids that are only valid since 2016
      # two digits appear zero times and one digit appears exactly three times and all other digits appear exactly once
      elsif (digits.select { |count| count.to_i == 2 }).count == 0 && (digits.select { |count| count.to_i == 3 }).count != 1 && (digits.select { |count| count.to_i == 1 }).count != 7
        out = false
      end
      out
    end
  end
end
