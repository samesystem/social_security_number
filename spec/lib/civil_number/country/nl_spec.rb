require 'spec_helper'

describe CivilNumber::Nl do
  subject(:civil_number) { CivilNumber::Nl.new(number) }

  describe '#validate' do
    let(:number) { '123456782' }

    context 'when number is valid' do
      it { is_expected.to be_valid }
    end

    context 'when number contains not digits' do
      let(:number) { '1234A5672' }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number contains not digits' do
      let(:number) { '1234A5672' }
      it { is_expected.to eq('it is not number') }
    end

    context 'when number length is invalid' do
      let(:number) { '1234567299988' }
      it { is_expected.to eq('number should be length of 9 or 8') }
    end
  end

  describe '#check_control_sum' do
    context 'when control number coincide with count number' do
      let(:number) { '123456782' }
      it { expect(civil_number.send(:check_control_sum)).to eq(true) }
    end

    context 'when control number not coincide with count number' do
      let(:number) { '12345672' }
      it { expect(civil_number.send(:check_control_sum)).to eq(false) }
    end
  end
end
