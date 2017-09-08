require 'spec_helper'

describe CivilNumber::Lt do
  subject(:civil_number) { CivilNumber::Lt.new(number) }

  describe '#validate' do
    let(:number) {'33309240064'}

    context 'when number is valid' do
      it { is_expected.to be_valid }
    end

    context 'when number contains not digits' do
      let(:number) {'3330A9240064'}
      it { is_expected.not_to be_valid }
    end
  end


  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number contains not digits' do
      let(:number) {'3330A9240064'}
      it { is_expected.to eq('it is not number') }
    end

    context 'when number length is invalid' do
      let(:number) {'33309240'}
      it { is_expected.to eq('number shuld be length of 11') }
    end

    context 'when number contains invalid birth date' do
      let(:number) {'88888840064'}
      it { is_expected.to eq('number birth date is invalid') }
    end

    context 'when number has bad control number' do
      let(:number) {'33309240068'}
      it { is_expected.to eq('number control sum invalid') }
    end
  end
end
