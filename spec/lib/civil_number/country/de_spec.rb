require 'spec_helper'

describe CivilNumber::De do
  subject(:civil_number) { CivilNumber::De.new(number) }

  describe '#validate' do
    let(:number) { '44567139207' }

    context 'when number is valid' do
      it { is_expected.to be_valid }
    end

    context 'when number contains not digits' do
      let(:number) { '44567A139207' }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number contains not digits' do
      let(:number) { '44567A139207' }
      it { is_expected.to eq('it is not number') }
    end

    context 'when number length is invalid' do
      let(:number) { '4456713920799' }
      it { is_expected.to eq('number shuld be length of 11') }
    end

    context 'when number has bad control number' do
      let(:number) { '44567139206' }
      it { is_expected.to eq('number control sum invalid') }
    end

    context 'when number has first zero digit' do
      let(:number) { '04567139206' }
      it { is_expected.to eq('first number is invalid') }
    end
  end

  describe '#check_control_sum' do
    let(:number) { '56214987054' }
    it { expect(civil_number.send(:count_last_number)).to eq(4) }
  end

  describe '#check_control_sum' do
    context 'when control number coincide with count number' do
      let(:number) { '33309240064' }
      it { expect(civil_number.send(:check_control_sum)).to eq(true) }
    end

    context 'when control number not coincide with count number' do
      let(:number) { '33309240063' }
      it { expect(civil_number.send(:check_control_sum)).to eq(false) }
    end
  end

  describe '#check_digits_apperings' do
    context 'correctly validates a valid 2015-tax-id' do
      let(:number) { '12345678995' }
      it { expect(civil_number.send(:check_control_sum)).to eq(true) }
    end

    context 'correctly invalidate a valid 2015-tax-id' do
      let(:number) { '12346678995' }
      it { expect(civil_number.send(:check_control_sum)).to eq(false) }
    end

    context 'correctly validates a valid 2016-tax-id' do
      let(:number) { '12345679998' }
      it { expect(civil_number.send(:check_control_sum)).to eq(true) }
    end

    context 'correctly invalidate a valid 2016-tax-id' do
      let(:number) { '12335679998' }
      it { expect(civil_number.send(:check_control_sum)).to eq(false) }
    end
  end
end
