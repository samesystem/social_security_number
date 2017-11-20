require 'spec_helper'

describe SocialSecurityNumber::Lt do
  subject(:civil_number) { SocialSecurityNumber::Lt.new(number) }

  describe '#validate' do
    let(:number) { '33309240064' }

    context 'when number is valid' do
      it { is_expected.to be_valid }
    end

    context 'when number contains not digits' do
      let(:number) { '3330A9240064' }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number contains not digits' do
      let(:number) { '3330A9240064' }
      it { is_expected.to eq('it is not number') }
    end

    context 'when number length is invalid' do
      let(:number) { '33309240' }
      it { is_expected.to eq('number should be length of 11') }
    end

    context 'when number contains invalid gender number' do
      let(:number) { '88888840064' }
      it { is_expected.to eq('gender number is not recognized') }
    end

    context 'when number contains invalid gender number' do
      let(:number) { '28888840064' }
      it { is_expected.to eq('number birth date is invalid') }
    end

    context 'when number has bad control number' do
      let(:number) { '33309240068' }
      it { is_expected.to eq('number control sum invalid') }
    end
  end

  describe '#check_control_sum' do
    let(:number) { '33309240064' }
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

  describe '#year' do
    before do
      civil_number.send(:parsed_civil_number)
    end
    context 'when receive valid value < 6' do
      let(:number) { '13309240064' }
      it { expect(civil_number.send(:year)).to eq(1833) }
    end

    context 'when receive invalid value > 6' do
      let(:number) { '83309240064' }
      it { expect(civil_number.send(:year)).to eq(33) }
    end
  end

  describe '#gender' do
    context 'when receive odd value' do
      let(:number) { '43309240064' }
      it { expect(civil_number.send(:gender)).to eq(:female) }
    end
  end
end
