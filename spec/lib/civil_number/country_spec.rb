require 'spec_helper'

describe CivilNumber::Country do
  subject(:civil_country) { CivilNumber::Country.new(number) }

  describe '#digit_number' do
    context 'number without divider' do
      let(:number) { '10014100176' }
      it { expect(civil_country.send(:digit_number)).to eq('10014100176') }
    end

    context 'number with divider' do
      let(:number) { '100141+00176' }
      it { expect(civil_country.send(:digit_number)).to eq('10014100176') }
    end
  end

  describe '#gender' do
    subject(:civil_number) { CivilNumber::Pk.new(number) }
    context 'when receive odd value' do
      let(:number) { '1210112345672' }
      it { expect(civil_number.send(:gender)).to eq(:female) }
    end
  end
end
