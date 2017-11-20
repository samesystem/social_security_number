require 'spec_helper'

describe SocialSecurityNumber::Us do
  subject(:civil_number) { SocialSecurityNumber::Us.new(number) }

  describe '#validate' do
    context 'when number is valid SSN' do
      let(:number) { '536-90-4399' }
      it { is_expected.to be_valid }
    end

    context 'when number is valid ITIN' do
      let(:number) { '912-90-3456' }
      it { is_expected.to be_valid }
    end

    context 'when number is valid EIN' do
      let(:number) { '91-1144442' }
      it { is_expected.to be_valid }
    end

    context 'when number contains not digits' do
      let(:number) { '0A6-454-286' }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when number contains not digits' do
      let(:number) { '0A6-454-286' }
      it { is_expected.to eq('bad number format') }
    end
  end
end
