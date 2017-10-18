require 'spec_helper'

describe CivilNumber::Mx do
  subject(:civil_number) { CivilNumber::Mx.new(number) }

  describe '#validate' do
    let(:number) {'GOMJ910711MTSMRS06'}

    context 'when number is valid' do
      it { is_expected.to be_valid }
    end

    context 'when number contains not digits' do
      let(:number) {'GOMJ910711MTSMRS0A'}
      it { is_expected.not_to be_valid }
    end
  end


  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number contains not digits' do
      let(:number) {'GOMJ910711MTSMRS0A'}
      it { is_expected.to eq('bad number format') }
    end

    context 'when number has bad birth date' do
      let(:number) {'GOMJ913311MTSMRS02'}
      it { is_expected.to eq('number birth date is invalid') }
    end

    context 'when number has bad control number' do
      let(:number) {'GOMJ910711MTSMRS02'}
      it { is_expected.to eq('number control sum invalid') }
    end
  end

  describe '#check_control_sum' do
    let(:number) {'GOMJ910711MTSMRS06'}
    it { expect(civil_number.send(:count_last_number)).to eq(6)}
  end

  describe '#check_control_sum' do
    context 'when control number coincide with count number' do
      let(:number) {'GOMJ910711MTSMRS06'}
      it { expect(civil_number.send(:check_control_sum)).to eq(true)}
    end

    context 'when control number not coincide with count number' do
      let(:number) {'GOMJ910711MTSMRS02'}
      it { expect(civil_number.send(:check_control_sum)).to eq(false)}
    end
  end

  describe '#base_year' do
    context 'when receive valid value' do
      let(:number) { 'GOMJ910711MTSMRS02' }
      it { expect(civil_number.send(:base_year, year: 2)).to eq(2002) }
    end

    context 'when receive invalid value' do
      let(:number) { 'GOMJ910711MTSMRS02' }
      it { expect(civil_number.send(:base_year, year: 40)).to eq(1940) }
    end
  end

  describe '#get_gender' do
    context 'when receive famale value' do
      let(:number) {'GOMJ910711MTSMRS06'}
      it { expect(civil_number.send(:get_gender,'W')).to eq(:female)}
    end
  end
end
