require 'spec_helper'

describe CivilNumber::Lt do
  subject(:civil_number) { CivilNumber::Lt.new(number) }

  describe '#validate' do
    let(:number) {'33309240064'}

    context 'when number is valid' do
      it { is_expected.to be_valid }
    end

    context 'when number contains not digits' do
      let(:number) {'3330A9240064'}
      it { is_expected.not_to be_valid }
    end
  end


  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number contains not digits' do
      let(:number) {'3330A9240064'}
      it { is_expected.to eq('it is not number') }
    end

    context 'when number length is invalid' do
      let(:number) {'33309240'}
      it { is_expected.to eq('number shuld be length of 11') }
    end

    context 'when number contains invalid gender number' do
      let(:number) {'88888840064'}
      it { is_expected.to eq('gender number is not recognaized') }
    end

    context 'when number contains invalid gender number' do
      let(:number) {'28888840064'}
      it { is_expected.to eq('number birth date is invalid') }
    end

    context 'when number has bad control number' do
      let(:number) {'33309240068'}
      it { is_expected.to eq('number control sum invalid') }
    end
  end

  describe '#check_control_sum' do
    let(:number) {'33309240064'}
    it { expect(civil_number.send(:count_last_number)).to eq(4)}
  end

  describe '#check_control_sum' do
    context 'when control number coincide with count number' do
      let(:number) {'33309240064'}
      it { expect(civil_number.send(:check_control_sum)).to eq(true)}
    end

    context 'when control number not coincide with count number' do
      let(:number) {'33309240063'}
      it { expect(civil_number.send(:check_control_sum)).to eq(false)}
    end
  end

  describe '#base_year' do
    context 'when receive valid value < 6' do
      let(:number) {'33309240064'}
      it { expect(civil_number.send(:base_year,{gender:2})).to eq(1800)}
    end

    context 'when receive invalid value > 6' do
      let(:number) {'33309240064'}
      it { expect(civil_number.send(:base_year,{gender:8})).to eq(0)}
    end
  end

  describe '#get_gender' do
    context 'when receive odd value' do
      let(:number) {'33309240064'}
      it { expect(civil_number.send(:get_gender,2)).to eq(:female)}
    end
  end

  describe '#gender_number' do
      let(:number) {'33309240064'}
      it { expect(civil_number.send(:gender_number)).to eq(3)}
  end

end
