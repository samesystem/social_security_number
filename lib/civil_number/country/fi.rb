module CivilNumber
  class Fi < Country
    def validate
      @error = if !check_by_regexp(REGEXP)
                 'bad number format'
               elsif !check_control_simbol
                 'number control sum invalid'
      end
    end

    private

    MODULUS = 31

    REGEXP = /^(?<day>\d{2})(?<month>\d{2})(?<year>\d{2})(?<century>[-+A])(?<individual>\d{3})(?<control>[0-9ABCDEFHJKLMNPRSTUVWXY])$/

    def check_control_simbol
      count_last_simbol.to_s == @control_number.to_s
    end

    def count_last_simbol
      number = "#{@civil_number[0..5]}#{@individual}"
      last_number = number.to_i % MODULUS
      '0123456789ABCDEFHJKLMNPRSTUVWXY'[last_number]
    end

    def base_year(year)
      offset_year = case @civil_number[6]
                    when '+'
                      1800
                    when '-'
                      1900
                    when 'A'
                      2000
      end
      offset_year + year[:year].to_i
    end
  end
end
