require 'spec_helper'

describe SocialSecurityNumber::Se do
  subject(:civil_number) { SocialSecurityNumber::Se.new(number) }

  describe '#validate' do
    let(:number) { '19391030-4298' }

    context 'when number is valid with divider' do
      it { is_expected.to be_valid }
    end

    context 'when number is valid with no divider' do
      let(:number) { '193910304298' }
      it { is_expected.to be_valid }
    end

    context 'when number is valid with short data' do
      let(:number) { '3910304298' }
      it { is_expected.to be_valid }
    end

    context 'when number contains not digits' do
      let(:number) { '19391AA030-4298' }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number contains not digits' do
      let(:number) { '19391AA030-4298' }
      it { is_expected.to eq('bad number format') }
    end

    context 'when number contains invalid birth date' do
      let(:number) { '99399999-4298' }
      it { is_expected.to eq('number birth date is invalid') }
    end

    context 'when number has bad control number' do
      let(:number) { '19391030-4296' }
      it { is_expected.to eq('number control sum invalid') }
    end
  end

  describe '#checksum' do
    let(:number) { '19391030-4296' }
    it { expect(civil_number.send(:checksum, :even)).to eq(42) }
  end

  describe '#check_control_digit' do
    context 'when control number coincide with count number' do
      let(:number) { '19391030-4298' }
      it { expect(civil_number.send(:check_control_digit)).to eq(true) }
    end

    context 'when control number not coincide with count number' do
      let(:number) { '19391030-4296' }
      it { expect(civil_number.send(:check_control_digit)).to eq(false) }
    end
  end

  describe '#year' do
    context 'when receive valid value' do
      let(:number) { '19391030-4296' }
      it { expect(civil_number.send(:year)).to eq(1939) }

      context 'when civil number is from 20th century' do
        let(:number) { '20151030-4296' }
        it { expect(civil_number.send(:year)).to eq(2015) }
      end

      context 'when civil number is from 20th century' do
        let(:number) { '19451030-4296' }
        it { expect(civil_number.send(:year)).to eq(1945) }
      end

      context 'when civil number is from 19th century' do
        let(:number) { '18881030-4296' }
        it { expect(civil_number.send(:year)).to eq(1888) }
      end
    end

    context 'when receive invalid value' do
      let(:number) { '1A9391030-4296' }
      it { expect(civil_number.send(:year)).to eq(0) }
    end
  end

  describe '#get_gender' do
    let(:number) { '19391030-4296' }
    context 'when receive odd value' do
      it { expect(civil_number.send(:gender)).to eq(:male) }
    end
  end
end
