require 'spec_helper'

describe SocialSecurityNumber::Es do
  subject(:civil_number) { SocialSecurityNumber::Es.new(number) }

  describe '#validate' do
    let(:number) { '11111111H' }

    context 'when DNI number is valid' do
      it { is_expected.to be_valid }
    end

    context 'when NIE number is valid' do
      let(:number) { 'Y1111111H' }
      it { is_expected.to be_valid }
    end

    context 'when number contains not digits' do
      let(:number) { 'Y1111Z11H' }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number contains digit as last simbol' do
      let(:number) { 'Y1111Z119' }
      it { is_expected.to eq('bad number format') }
    end

    context 'when number length is invalid' do
      let(:number) { 'Y1111Z11AAAA' }
      it { is_expected.to eq('bad number format') }
    end
  end

  describe '#dni_validation' do
    context 'when number valid' do
      let(:number) { '11111111H' }
      it { expect(civil_number.send(:dni_validation)).to eq(true) }
    end
  end

  describe '#nie_validation' do
    context 'when number valid' do
      let(:number) { 'Y1111111H' }
      it { expect(civil_number.send(:nie_validation)).to eq(true) }
    end
  end

  describe '#count_last_simbol' do
    let(:number) { '11111111H' }
    it 'when control number coincide with count number' do
      expect(civil_number.send(:count_last_simbol, '11111111')).to eq('H')
    end
  end
end
