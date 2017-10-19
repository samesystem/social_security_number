require 'spec_helper'

describe CivilNumber::Ch do
  subject(:civil_number) { CivilNumber::Ch.new(number) }

  describe '#validate' do
    let(:number) { '756.1234.5678.97' }

    context 'when number is valid' do
      it { is_expected.to be_valid }
    end

    context 'when number contains not digits' do
      let(:number) { '756.123A.5678.97' }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number contains not digits' do
      let(:number) { '75A.1234.5678.97' }
      it { is_expected.to eq('bad number format') }
    end

    context 'when number has bad control number' do
      let(:number) { '756.1234.5678.90' }
      it { is_expected.to eq('number control sum invalid') }
    end
  end

  describe '#count_last_number' do
    describe 'count control digit' do
      let(:number) { '756.1234.5678.90' }
      it { expect(civil_number.send(:count_last_number)).to eq(7) }
    end
  end

  describe '#check_control_sum' do
    context 'when control number coincide with count number' do
      let(:number) { '756.1234.5678.97' }
      it { expect(civil_number.send(:check_control_sum)).to eq(true) }
    end

    context 'when control number not coincide with count number' do
      let(:number) { '756.1234.5678.90' }
      it { expect(civil_number.send(:check_control_sum)).to eq(false) }
    end
  end
end
