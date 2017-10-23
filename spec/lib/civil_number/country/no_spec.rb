require 'spec_helper'

describe CivilNumber::No do
  subject(:civil_number) { CivilNumber::No.new(number) }
  before do
    civil_number.send(:parsed_civil_number)
  end

  describe '#validate' do
    let(:number) { '10010100173' }

    context 'when number is valid' do
      it { is_expected.to be_valid }
    end

    context 'when number is valid with divider -' do
      let(:number) { '100101-00173' }
      it { is_expected.to be_valid }
    end

    context 'when number is valid with divider +' do
      let(:number) { '100101+00173' }
      it { is_expected.to be_valid }
    end

    context 'when number is valid D-number' do
      let(:number) { '100161-00132' }
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
      let(:number) { '1001AA0100177' }
      it { is_expected.to eq('bad number format') }
    end

    context 'when number contains invalid birth date' do
      let(:number) { '10900100177' }
      it { is_expected.to eq('number birth date is invalid') }
    end

    context 'when number has bad control number' do
      let(:number) { '10010100167' }
      it { is_expected.to eq('first control code invalid') }
    end

    context 'when number has bad control number' do
      let(:number) { '10010100176' }
      it { is_expected.to eq('second control code invalid') }
    end
  end

  describe '#year' do
    context 'when receive valid value' do
      context 'when civil number is from 21st century' do
        let(:number) { '290200-91020' }
        it { expect(civil_number.send(:year)).to eq(2000) }
      end

      context 'when civil number is from 20th century' do
        let(:number) { '020945-90520' }
        it { expect(civil_number.send(:year)).to eq(1945) }
      end

      context 'when civil number is from 19th century' do
        let(:number) { '050588-70120' }
        it { expect(civil_number.send(:year)).to eq(1888) }
      end
    end

    context 'when receive valid value' do
      let(:number) { '10014100176' }
      it { expect(civil_number.send(:year)).to eq(1941) }
    end

    context 'when receive invalid value' do
      let(:number) { '10014A00176' }
      it { expect(civil_number.send(:year)).to eq(0) }
    end
  end

  describe '#day' do
    context 'when simple value' do
      let(:number) { '10014100176' }
      it { expect(civil_number.send(:day)).to eq(10) }
    end

    context 'when receive extended value' do
      let(:number) { '50014100176' }
      it { expect(civil_number.send(:day)).to eq(10) }
    end
  end

  describe '#gender' do
    context 'when receive odd value' do
      let(:number) { '10014100176' }
      it { expect(civil_number.send(:gender)).to eq(:male) }
    end
  end
end
