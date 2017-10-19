require 'spec_helper'

describe CivilNumber::Ca do
  subject(:civil_number) { CivilNumber::Ca.new(number) }

  describe '#validate' do
    let(:number) { '046-454-286' }

    context 'when number is valid' do
      it { is_expected.to be_valid }
    end

    context 'when number contains not digits' do
      let(:number) { '0A6-454-286' }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number contains not digits' do
      let(:number) { '0A6-454-286' }
      it { is_expected.to eq('bad number format') }
    end

    context 'when number has bad control number' do
      let(:number) { '046-454-281' }
      it { is_expected.to eq('number control sum invalid') }
    end
  end

  describe '#count_number_sum' do
    let(:number) { '046-454-286' }
    it { expect(civil_number.send(:count_number_sum)).to eq(50) }
  end

  describe '#check_number' do
    context 'when number sum divisible by 10' do
      let(:number) { '046-454-286' }
      it { expect(civil_number.send(:check_number)).to eq(true) }
    end

    context 'when number sum not divisible by 10' do
      let(:number) { '046-454-285' }
      it { expect(civil_number.send(:check_number)).to eq(false) }
    end
  end
end
