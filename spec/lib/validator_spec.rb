require 'spec_helper'

describe CivilNumber::Validator do
  describe '#valid?' do
    it 'when civil numer is not valid validtor must cointain error' do
      cv = CivilNumber::Validator.new(number: '8988990707', country_code: 'lt')
      cv.valid?
      expect(cv.error).not_to be_nil
    end

    it 'when civil numer is valid validtor must cointain no errors' do
      cv = CivilNumber::Validator.new(number: '33309240064', country_code: 'lt')
      cv.valid?
      expect(cv.error).to be_nil
    end

    context 'validate gender' do
      it 'when receice gender and country has gender in civil number' do
        cv = CivilNumber::Validator.new(number: '33309240064',
                                        country_code: 'lt', gender: 'female')
        cv.valid?
        expect(cv.error).to eq('gender female dont match male')
      end

      it 'call Cn class method' do
        cv = CivilNumber::Validator.new(number: '111111200102021118',
                                        country_code: 'cn', gender: 'female')
        cv.valid?
        expect(cv.error).to eq('gender female dont match male')
      end
    end

    context 'validate birth_date' do
      context 'when receice birth_date' do
        it 'and country dont have birth_date in civil number' do
          cv = CivilNumber::Validator.new(number: '755490976',
                                          country_code: 'nl',
                                          birth_date: '2010-01-01')
          expect(cv).to be_valid
          expect(cv.error).to be_nil
        end

        it 'and country have birth_date in civil number' do
          cv = CivilNumber::Validator.new(number: '33309240064',
                                          country_code: 'lt',
                                          birth_date: '1933-09-24')
          expect(cv).to be_valid
          expect(cv.error).to be_nil
        end

        it 'and country have birth_date in civil number in date format' do
          cv = CivilNumber::Validator.new(number: '33309240064',
                                          country_code: 'lt',
                                          birth_date: Date.new(1933, 9, 24))
          expect(cv).to be_valid
          expect(cv.error).to be_nil
        end
      end
    end
  end
end
