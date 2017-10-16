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

  describe '#base_year' do
    context 'when receive valid value' do
      let(:number) { '10014100176' }
      it { expect(civil_number.send(:base_year, year: 2)).to eq(2002) }
    end

    context 'when receive invalid value' do
      let(:number) { '10014100176' }
      it { expect(civil_number.send(:base_year, year: 40)).to eq(1940) }
    end
  end

  describe '#get_gender' do
    context 'when receive odd value' do
      let(:number) { '10014100176' }
      it { expect(civil_number.send(:get_gender, 2)).to eq(:female) }
    end
  end

  describe '#number' do
    context 'number without divider' do
      let(:number) { '10014100176' }
      it { expect(civil_number.send(:number)).to eq('10014100176') }
    end

    context 'number with divider' do
      let(:number) { '100141+00176' }
      it { expect(civil_number.send(:number)).to eq('10014100176') }
    end
  end
end
