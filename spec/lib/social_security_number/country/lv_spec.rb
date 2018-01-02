require 'spec_helper'

describe SocialSecurityNumber::Lv do
  subject(:civil_number) { SocialSecurityNumber::Lv.new(number) }

  describe '#validate' do
    let(:number) { '16117519997' }

    context 'when number is valid' do
      it { is_expected.to be_valid }
    end

    context 'when number is in new format' do
      let(:number) { '32137519997' }
      it { is_expected.to be_valid }
    end

    context 'when number contains not digits' do
      let(:number) { '161375-19997' }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number contains not digits' do
      let(:number) { '3330A9240064' }
      it { is_expected.to eq('bad number format') }
    end
  end

  describe '#check_control_sum' do
    let(:number) { '16117519997' }
    it { expect(civil_number.send(:count_last_number)).to eq(7) }
  end

  describe '#check_control_sum' do
    context 'when control number coincide with count number' do
      let(:number) { '16117519997' }
      it { expect(civil_number.send(:check_control_sum)).to eq(true) }
    end

    context 'when control number not coincide with count number' do
      let(:number) { '16117519996' }
      it { expect(civil_number.send(:check_control_sum)).to eq(false) }
    end
  end

  describe '#base_year' do
    context 'when receive valid value' do
      let(:number) { '16117519996' }
      it { expect(civil_number.send(:base_year, 2)).to eq(2002) }
    end

    context 'when receive invalid value' do
      let(:number) { '16117519996' }
      it { expect(civil_number.send(:base_year, 40)).to eq(1940) }
    end
  end
end
