require 'spec_helper'

describe SocialSecurityNumber::Cz do
  subject(:civil_number) { SocialSecurityNumber::Cz.new(number) }

  describe '#validate' do
    let(:number) { '685229/4449' }

    context 'when number is valid pre 1985' do
      it { is_expected.to be_valid }
    end

    context 'when number is valid pre 1985 with 0' do
      let(:number) { '685229/444' }
      it { is_expected.to be_valid }
    end

    context 'when number is valid after 1985' do
      let(:number) { '685229/444' }
      it { is_expected.to be_valid }
    end

    context 'when number contains not digits' do
      let(:number) { '685229/44A9' }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number contains not digits' do
      let(:number) { '685229/44A9' }
      it { is_expected.to eq('bad number format') }
    end

    context 'when number length is invalid' do
      let(:number) { '11211111200102021111' }
      it { is_expected.to eq('bad number format') }
    end

    context 'when number has bad birth date' do
      let(:number) { '685289/4449' }
      it { is_expected.to eq('number birth date is invalid') }
    end
  end

  describe '#count_last_number' do
    describe 'count control digit' do
      let(:number) { '685229/4449' }
      it { expect(civil_number.send(:count_last_number)).to eq(9) }
    end
  end

  describe '#check_control_sum' do
    context 'when control number coincide with count number' do
      let(:number) { '685229/4449' }
      it { expect(civil_number.send(:check_control_sum)).to eq(true) }
    end

    context 'when control number not coincide with count number' do
      let(:number) { '685229/4448' }
      it { expect(civil_number.send(:check_control_sum)).to eq(false) }
    end

    context 'when control number not provided' do
      let(:number) { '685229/444' }
      it { expect(civil_number.send(:check_control_sum)).to eq(true) }
    end
  end

  describe '#year' do
    context 'when receive value' do
      let(:number) { '685229/444' }
      it { expect(civil_number.send(:year)).to eq(1968) }
    end
  end

  describe '#month' do
    context 'when receive with famale value' do
      let(:number) { '685429/444' }
      it { expect(civil_number.send(:month)).to eq(4) }
    end

    context 'when receive extended famale value' do
      let(:number) { '687429/444' }
      it { expect(civil_number.send(:month)).to eq(4) }
    end

    context 'when receive with male value' do
      let(:number) { '681229/444' }
      it { expect(civil_number.send(:month)).to eq(12) }
    end

    context 'when receive extended male value' do
      let(:number) { '682229/444' }
      it { expect(civil_number.send(:month)).to eq(2) }
    end
  end

  describe '#gender' do
    context 'when receive famale value' do
      let(:number) { '685429/444' }
      it { expect(civil_number.send(:gender)).to eq(:famale) }
    end

    context 'when receive male value' do
      let(:number) { '680429/444' }
      it { expect(civil_number.send(:gender)).to eq(:male) }
    end
  end
end
