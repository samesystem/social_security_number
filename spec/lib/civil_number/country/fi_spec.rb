require 'spec_helper'

describe CivilNumber::Fi do
  subject(:civil_number) { CivilNumber::Fi.new(number) }

  describe '#validate' do
    let(:number) { '131052-308T' }

    context 'when number is valid' do
      it { is_expected.to be_valid }
    end

    context 'when number format is to long' do
      let(:number) { '3131052-308T' }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number contains not digits' do
      let(:number) { '1A1052-308T' }
      it { is_expected.to eq('bad number format') }
    end

    context 'when number has bad control number' do
      let(:number) { '131052-308B' }
      it { is_expected.to eq('number control sum invalid') }
    end
  end

  describe '#count_last_simbol' do
    let(:number) { '131052-308T' }
    it { expect(civil_number.send(:count_last_simbol)).to eq('T') }
  end

  describe '#check_control_simbol' do
    context 'when control number coincide with count number' do
      let(:number) { '131052-308T' }
      it { expect(civil_number.send(:check_control_simbol)).to eq(true) }
    end

    context 'when control number not coincide with count number' do
      let(:number) { '131052-308A' }
      it { expect(civil_number.send(:check_control_simbol)).to eq(false) }
    end
  end

  describe '#year' do
    context 'when receive valid value with -' do
      let(:number) { '131052-308T' }
      it { expect(civil_number.send(:year)).to eq(1952) }
    end

    context 'when receive valid value with A' do
      let(:number) { '131002A308T' }
      it { expect(civil_number.send(:year)).to eq(2002) }
    end
  end
end
