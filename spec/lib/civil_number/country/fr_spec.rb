require 'spec_helper'

describe CivilNumber::Fr do
  subject(:civil_number) { CivilNumber::Fr.new(number) }

  describe '#validate' do
    let(:number) { '111111111111120' }

    context 'when number is valid' do
      it { is_expected.to be_valid }
    end

    context 'when number contains not digits' do
      let(:number) { 'A11111111111120' }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number length is invalid' do
      let(:number) { '1111111111111201111' }
      it { is_expected.to eq('bad number format') }
    end

    context 'when number has bad control number' do
      let(:number) { '111111111111111' }
      it { is_expected.to eq('number control sum invalid') }
    end
  end

  describe '#count_last_number' do
    context 'when number contains A' do
      let(:number) { '111111A11111111' }
      it { expect(civil_number.send(:count_last_number)).to eq(51) }
    end

    context 'when number contains B' do
      let(:number) { '111111B11111111' }
      it { expect(civil_number.send(:count_last_number)).to eq(51) }
    end

    context 'when number contains only digits' do
      let(:number) { '111111111111111' }
      it { expect(civil_number.send(:count_last_number)).to eq(20) }
    end
  end

  describe '#check_control_sum' do
    context 'when control number coincide with count number' do
      let(:number) { '111111111111120' }
      it { expect(civil_number.send(:check_control_sum)).to eq(true) }
    end

    context 'when control number not coincide with count number' do
      let(:number) { '111111B11111111' }
      it { expect(civil_number.send(:check_control_sum)).to eq(false) }
    end
  end

  describe '#year' do
    context 'when receive value' do
      let(:number) { '111111B11111111' }
      it { expect(civil_number.send(:year)).to eq(2011) }
    end

    context 'when receive value' do
      let(:number) { '189111B11111111' }
      it { expect(civil_number.send(:year)).to eq(1989) }
    end
  end
end
