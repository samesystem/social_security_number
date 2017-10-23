require 'spec_helper'

describe CivilNumber::Dk do
  subject(:civil_number) { CivilNumber::Dk.new(number) }

  describe '#validate' do
    let(:number) { '1004932990' }

    context 'when number is valid' do
      it { is_expected.to be_valid }
    end

    context 'when number is valid with divider -' do
      let(:number) { '100493-2990' }
      it { is_expected.to be_valid }
    end

    context 'when number contains not digits' do
      let(:number) { '10010A100177' }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number contains not digits' do
      let(:number) { '10049A32990' }
      it { is_expected.to eq('bad number format') }
    end

    context 'when number contains invalid birth date' do
      let(:number) { '9004932990' }
      it { is_expected.to eq('number birth date is invalid') }
    end

    context 'when number has bad control number' do
      let(:number) { '311277-0005' }
      it { is_expected.to eq('control code invalid') }
    end
  end

  describe '#year' do
    context 'when receive valid value' do
      context 'when civil number is from 21st century' do
        let(:number) { '1004022990' }
        it { expect(civil_number.send(:year)).to eq(2002) }
      end

      context 'when civil number is from 20th century' do
        let(:number) { '1004402990' }
        it { expect(civil_number.send(:year)).to eq(1940) }
      end
    end
  end

  describe '#gender' do
    context 'when receive odd value' do
      let(:number) { '1004402990' }
      it { expect(civil_number.send(:gender)).to eq(:female) }
    end
  end
end
