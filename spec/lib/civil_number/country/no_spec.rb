require 'spec_helper'

describe CivilNumber::No do
  subject(:civil_number) { CivilNumber::No.new(number) }

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

  describe '#check_date' do
    let(:number) { '10010100176' }
    context 'validate date' do
      it { expect(civil_number.send(:check_date)).to eq(true) }
    end

    context 'validate D-number date' do
      let(:number) { '10014100176' }
      it { expect(civil_number.send(:check_date)).to eq(true) }
    end
  end

  describe '#base_year' do
    context 'when receive valid value' do
      let(:number) { '10014100176' }
      it { expect(civil_number.send(:base_year, individual_number: 0o0, gender: 1)).to eq(1900) }
    end

    context 'when receive invalid value' do
      let(:number) { '10014100176' }
      it { expect(civil_number.send(:base_year, individual_number: 100, gender: 1)).to eq(0) }
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
