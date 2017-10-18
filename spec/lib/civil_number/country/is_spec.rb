require 'spec_helper'

describe CivilNumber::Is do
  subject(:civil_number) { CivilNumber::Is.new(number) }

  describe '#validate' do
    let(:number) { '120174-3399' }

    context 'when number personal is valid' do
      it { is_expected.to be_valid }
    end

    context 'when number organisation is valid' do
      let(:number) { '450401-3150' }
      it { is_expected.to be_valid }
    end

    context 'when format is bad' do
      let(:number) { 'A50401-3150' }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number contains not digits' do
      let(:number) { 'A50401-3150' }
      it { is_expected.to eq('bad number format') }
    end

    context 'when number contains invalid birth date' do
      let(:number) { '459901-3150' }
      it { is_expected.to eq('number birth date is invalid') }
    end

    context 'when number has bad control number' do
      let(:number) {'120174-3329'}
      it { is_expected.to eq('number control sum invalid') }
    end
  end

  describe '#count_control_number' do
    let(:number) {'120174-3329'}
    it { expect(civil_number.send(:count_control_number)).to eq(9)}
  end

  describe '#check_control_sum' do
    context 'when control number coincide with count number' do
      let(:number) {'120174-3399'}
      it { expect(civil_number.send(:check_control_sum)).to eq(true)}
    end

    context 'when control number not coincide with count number' do
      let(:number) {'120174-3329'}
      it { expect(civil_number.send(:check_control_sum)).to eq(false)}
    end
  end

  describe '#base_year' do
    context 'when receive value 2000 +' do
      let(:number) { '120174-3329' }
      it { expect(civil_number.send(:base_year, year: 2)).to eq(2002) }
    end

    context 'when receive value 1900 +' do
      let(:number) { '120174-3329' }
      it { expect(civil_number.send(:base_year, year: 40)).to eq(1940) }
    end
  end
end
