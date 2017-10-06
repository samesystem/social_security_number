require 'spec_helper'

describe CivilNumber::Ch do
  subject(:civil_number) { CivilNumber::Ch.new(number) }

  describe '#validate' do
    let(:number) {'111111200102021118'}

    context 'when number is valid' do
      it { is_expected.to be_valid }
    end

    context 'when number contains not digits' do
      let(:number) {'111111200102021111'}
      it { is_expected.not_to be_valid }
    end
  end

  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number contains not digits' do
      let(:number) {'11A111200102021111'}
      it { is_expected.to eq('it is not number') }
    end

    context 'when number length is invalid' do
      let(:number) {'11211111200102021111'}
      it { is_expected.to eq('bad number format') }
    end

    context 'when number has bad control number' do
      let(:number) {'111111200102021111'}
      it { is_expected.to eq('number control sum invalid') }
    end

    context 'when number contains invalid gender number' do
      let(:number) {'111111200992021111'}
      it { is_expected.to eq('number birth date is invalid') }
    end
  end

  describe '#count_last_number' do
    describe 'count control digit' do
      let(:number) {'111111200102021118'}
      it { expect(civil_number.send(:count_last_number)).to eq(8)}
    end
  end

  describe '#check_control_sum' do
    context 'when control number coincide with count number' do
      let(:number) {'111111200102021118'}
      it { expect(civil_number.send(:check_control_sum)).to eq(true)}
    end

    context 'when control number not coincide with count number' do
      let(:number) {'111111200102021112'}
      it { expect(civil_number.send(:check_control_sum)).to eq(false)}
    end
  end

  describe '#base_year' do
    context 'when receive value' do
      let(:number) {'111111200102021118'}
      it { expect(civil_number.send(:base_year,{year:2003})).to eq(2003)}
    end
  end
end
