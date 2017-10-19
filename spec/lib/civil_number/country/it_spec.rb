require 'spec_helper'

describe CivilNumber::It do
  subject(:civil_number) { CivilNumber::It.new(number) }

  describe '#validate' do
    let(:number) { 'AAAAAA97T55A111A' }

    context 'when number is valid' do
      it { is_expected.to be_valid }
    end

    context 'when number is valid with divider -' do
      let(:number) { 'AAAAAA-97E54A111A' }
      it { is_expected.to be_valid }
    end

    context 'when format is bad' do
      let(:number) { 'AA1AAAA97T55A111A0' }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number contains not digits' do
      let(:number) { 'AAAAAA-9A7E54A111A' }
      it { is_expected.to eq('bad number format') }
    end

    context 'when number contains invalid birth date' do
      let(:number) { 'AAAAAA-97A94A111A' }
      it { is_expected.to eq('number birth date is invalid') }
    end
  end

  describe '#year' do
    context 'when receive valid value' do
      let(:number) { 'AAAAAA02T55A111A' }
      it { expect(civil_number.send(:year)).to eq(2002) }
    end

    context 'when receive invalid value' do
      let(:number) { 'AAAAAA97T55A111A' }
      it { expect(civil_number.send(:year)).to eq(1997) }
    end
  end
end
