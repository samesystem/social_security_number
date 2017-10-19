require 'spec_helper'

describe CivilNumber::Pk do
  subject(:civil_number) { CivilNumber::Pk.new(number) }

  describe '#validate' do
    let(:number) { '1210112345671' }

    context 'when number is valid' do
      it { is_expected.to be_valid }
    end

    context 'when number is valid with divider -' do
      let(:number) { '12101-1234567-1' }
      it { is_expected.to be_valid }
    end

    context 'when format is bad' do
      let(:number) { '1b10112A45671' }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number contains not digits' do
      let(:number) { '1b10112A45671' }
      it { is_expected.to eq('bad number format') }
    end
  end
end
