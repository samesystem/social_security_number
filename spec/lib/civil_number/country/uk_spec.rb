require 'spec_helper'

describe CivilNumber::Uk do
  subject(:civil_number) { CivilNumber::Uk.new(number) }

  describe '#validate' do
    let(:number) { 'AA 11 11 11 A' }

    context 'when NINO number is valid' do
      it { is_expected.to be_valid }
    end

    context 'when NHS number is valid' do
      let(:number) { '9434765919' }
      it { is_expected.to be_valid }
    end

    context 'when CHI number is valid' do
      let(:number) { '2202221111' }
      it { is_expected.to be_valid }
    end

    context 'when number contains not digits' do
      let(:number) { 'AO 11 11 11 A' }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number contains O as second letter' do
      let(:number) { 'AO 11 11 11 A' }
      it { is_expected.to eq('bad number format') }
    end

    context 'when number length is invalid' do
      let(:number) { '9902221111' }
      it { is_expected.to eq('bad nhs or chi number') }
    end
  end

  describe '#check_control_sum' do
    let(:number) { '9902221181' }
    it { expect(civil_number.send(:count_last_number)).to eq(1) }
  end

  describe '#check_control_sum' do
    context 'when control number coincide with count number' do
      let(:number) { '9902221114' }
      it { expect(civil_number.send(:check_control_sum)).to eq(true) }
    end

    context 'when control number not coincide with count number' do
      let(:number) { '9902221113' }
      it { expect(civil_number.send(:check_control_sum)).to eq(false) }
    end
  end

  describe '#base_year' do
    context 'when receive valid value' do
      let(:number) { '1902221111' }
      it { expect(civil_number.send(:base_year, 2)).to eq(2002) }
    end

    context 'when receive invalid value' do
      let(:number) { '9902221111' }
      it { expect(civil_number.send(:base_year, 40)).to eq(1940) }
    end
  end
end
