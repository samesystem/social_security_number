require 'spec_helper'

describe CivilNumber::Country do
  subject(:civil_country) { CivilNumber::Country.new(number) }

  describe '#digit_number' do
    context 'number without divider' do
      let(:number) { '10014100176' }
      it { expect(civil_country.send(:digit_number)).to eq('10014100176') }
    end

    context 'number with divider' do
      let(:number) { '100141+00176' }
      it { expect(civil_country.send(:digit_number)).to eq('10014100176') }
    end
  end

  describe '#gender' do
    subject(:civil_number) { CivilNumber::Pk.new(number) }
    context 'when receive odd value' do
      let(:number) { '1210112345672' }
      it { expect(civil_number.send(:gender)).to eq(:female) }
    end
  end

  describe '#year' do
    subject(:civil_number) { CivilNumber::Be.new(number) }

    context 'when civil number is from 21th century' do
      let(:number) { '11111111120' }
      it { expect(civil_number.send(:year)).to eq(2011) }
    end

    context 'when civil number is from 20th century' do
      let(:number) { '59111111120' }
      it { expect(civil_number.send(:year)).to eq(1959) }
    end
  end

  describe '#month' do
    subject(:civil_number) { CivilNumber::Be.new(number) }

    context 'month value' do
      let(:number) { '11111111120' }
      it { expect(civil_number.send(:month)).to eq(11) }
    end
  end

  describe '#day' do
    subject(:civil_number) { CivilNumber::Be.new(number) }

    context 'day value' do
      let(:number) { '11111111120' }
      it { expect(civil_number.send(:day)).to eq(11) }
    end
  end

  describe '#parsed_civil_number' do
    subject(:civil_number) { CivilNumber::Be.new(number) }

    context 'parsed_civil_number values' do
      let(:number) { '11111111120' }
      array = ["11111111120", "11", "11", "11", "111", "20"]
      it { expect(civil_number.send(:parsed_civil_number).to_a).to eq(array) }
    end
  end

  describe '#date' do
    subject(:civil_number) { CivilNumber::Be.new(number) }

    context 'valid value' do
      let(:number) { '11111111120' }
      it { expect(civil_number.send(:date).to_s).to eq('2011-11-11') }
    end
  end

  describe '#value_from_parsed_civil_number' do
    subject(:civil_number) { CivilNumber::Be.new(number) }

    context 'valid value' do
      let(:number) { '11111111120' }
      it { expect(civil_number.send(:value_from_parsed_civil_number, 'ctrl')).to eq('20') }
    end
  end
end
