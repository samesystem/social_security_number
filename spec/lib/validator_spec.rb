require 'spec_helper'

describe CivilNumber::Validator do

  describe '#valid?' do

    it 'when civil numer is not valid validtor must cointain error' do
      cv = CivilNumber::Validator.new({number:'8988990707', country_code:'lt'})
      cv.valid?
      expect(cv.error).not_to be_nil
    end

    it 'when civil numer is valid validtor must cointain no errors' do
      cv = CivilNumber::Validator.new({number:'33309240064', country_code:'lt'})
      cv.valid?
      expect(cv.error).to be_nil
    end
#context
    it 'when validator receice gender and country has gender in civil number' do
      cv = CivilNumber::Validator.new({number:'33309240064', country_code:'lt', gender:'female'})
      cv.valid?
      expect(cv.error).to eq('gender female dont match male')
    end

#context
    it 'when validator receice birth_date and country dont have birth_date in civil number' do
      cv = CivilNumber::Validator.new({number:'755490976', country_code:'nl', birth_date:'2010-01-01'})
      expect(cv).to be_valid
      expect(cv.error).to be_nil
    end

    it 'when validator receice birth_date and country have birth_date in civil number' do
      cv = CivilNumber::Validator.new({number:'33309240064', country_code:'lt', birth_date:'1933-09-24'})
      expect(cv).to be_valid
      expect(cv.error).to be_nil
    end

    it 'when validator receice birth_date and country have birth_date in civil number in date format' do
      cv = CivilNumber::Validator.new({number:'33309240064', country_code:'lt', birth_date:Date.new(1933, 9, 24)})
      expect(cv).to be_valid
      expect(cv.error).to be_nil
    end
  end
end
