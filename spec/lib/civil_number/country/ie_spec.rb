require 'spec_helper'

describe SocialSecurityNumber::Ie do
  subject(:civil_number) { SocialSecurityNumber::Ie.new(number) }

  describe '#validate' do
    let(:number) { '1234567T' }

    context 'when number is valid' do
      it { is_expected.to be_valid }
    end

    context 'when number is valid pre-2013 with special final "T"' do
      let(:number) { '6433435FT' }
      it { is_expected.to be_valid }
    end

    context 'when number is valid 2013 format' do
      let(:number) { '6433435OA' }
      it { is_expected.to be_valid }
    end

    context 'when number is valid 2013 format (non-personal)' do
      let(:number) { '6433435IH' }
      it { is_expected.to be_valid }
    end
  end

  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number contains not digits' do
      let(:number) { '6AA433435IH' }
      it { is_expected.to eq('bad number format') }
    end

    context 'when number has bad control number' do
      let(:number) { '1234567A' }
      it { is_expected.to eq('number control sum invalid') }
    end
  end

  describe '#count_last_simbol' do
    describe 'count control simbol for pre 2013 codes' do
      let(:number) { '1234567T' }
      it { expect(civil_number.send(:count_last_simbol)).to eq('T') }
    end

    describe 'count control simbol for 2013 codes' do
      let(:number) { '6433435OA' }
      it { expect(civil_number.send(:count_last_simbol)).to eq('O') }
    end
  end

  describe '#check_control_simbol' do
    context 'when control number coincide with count number' do
      let(:number) { '1234567T' }
      it { expect(civil_number.send(:check_control_simbol)).to eq(true) }
    end

    context 'when control number not coincide with count number' do
      let(:number) { '1234567D' }
      it { expect(civil_number.send(:check_control_simbol)).to eq(false) }
    end
  end
end
