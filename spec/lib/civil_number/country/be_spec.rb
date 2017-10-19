require 'spec_helper'

describe CivilNumber::Be do
  subject(:civil_number) { CivilNumber::Be.new(number) }

  describe '#validate' do
    let(:number) { '11111111150' }

    context 'when number is valid' do
      it { is_expected.to be_valid }
    end

    context 'when number contains not digits' do
      let(:number) { '1A111111150' }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number contains not digits' do
      let(:number) { 'A1111111150' }
      it { is_expected.to eq('bad number format') }
    end

    context 'when number length is invalid' do
      let(:number) { '1111111111150' }
      it { is_expected.to eq('bad number format') }
    end

    context 'when number has bad control number' do
      let(:number) { '11111111111' }
      it { is_expected.to eq('number control sum invalid') }
    end
  end

  describe '#check_control_sum' do
    context 'when number generated before 2000' do
      let(:number) { '11111111111' }
      it { expect(civil_number.send(:count_last_number)).to eq(60) }
    end

    context 'when number generated after 2000' do
      let(:number) { '11111111111' }
      it { expect(civil_number.send(:count_last_number, 2)).to eq(50) }
    end
  end

  describe '#check_control_sum' do
    context 'when control number coincide with count number' do
      let(:number) { '11111111160' }
      it { expect(civil_number.send(:check_control_sum)).to eq(true) }
    end

    context 'when control number not coincide with count number' do
      let(:number) { '11111111120' }
      it { expect(civil_number.send(:check_control_sum)).to eq(false) }
    end
  end

  describe '#year' do
    context 'when receive valid value < 6' do
      let(:number) { '11111111120' }
      it { expect(civil_number.send(:year)).to eq(2011) }
    end
  end
end
