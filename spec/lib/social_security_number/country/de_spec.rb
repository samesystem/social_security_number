# frozen_string_literal: true

require 'spec_helper'

describe SocialSecurityNumber::De do
  let(:is_rvnr) { false }
  subject(:civil_number) { described_class.new(number, is_rvnr) }

  describe '#validate' do
    context 'when number is Steuer-IdNr' do
      let(:is_rvnr) { false }

      context 'when number is valid' do
        let(:number) { '44567139207' }
        it { is_expected.to be_valid }
      end

      context 'when number contains non-digits' do
        let(:number) { '44567A139207' }
        it { is_expected.not_to be_valid }
      end
    end

    context 'when number is RVNR' do
      let(:is_rvnr) { true }

      context 'when the number is valid' do
        let(:number) { '58150668G898' }
        it { is_expected.to be_valid }
      end
    end
  end

  describe '#error' do
    context 'when number is Steuer-IdNr' do
      let(:is_rvnr) { false }

      context 'when number contains non-digits' do
        let(:number) { '44567A139207' }
        it 'returns the correct error message' do
          civil_number.valid?
          expect(civil_number.error).to eq('it is not number')
        end
      end

      context 'when number length is invalid' do
        let(:number) { '4456713920799' }
        it 'returns the correct error message' do
          civil_number.valid?
          expect(civil_number.error).to eq('number should be length of 11')
        end
      end

      context 'when number has bad control number' do
        let(:number) { '44567139206' }
        it 'returns the correct error message' do
          civil_number.valid?
          expect(civil_number.error).to eq('number control sum invalid')
        end
      end

      context 'when number has first zero digit' do
        let(:number) { '04567139206' }
        it 'returns the correct error message' do
          civil_number.valid?
          expect(civil_number.error).to eq('first number is invalid')
        end
      end
    end

    context 'when number is RVNR' do
      let(:is_rvnr) { true }

      context 'when full number length is invalid' do
        let(:number) { '58150668G8982' }
        it 'returns the correct error message' do
          civil_number.valid?
          expect(civil_number.error).to eq('number should be length of 12')
        end
      end

      context 'when the area number is invalid' do
        let(:number) { '62150668G898' }
        it 'returns the correct error message' do
          civil_number.valid?
          expect(civil_number.error).to eq('invalid area number')
        end
      end

      context 'when the birth date is invalid' do
        let(:number) { '58151668G898' }
        it 'returns the correct error message' do
          civil_number.valid?
          expect(civil_number.error).to eq('invalid date of birth')
        end
      end

      context 'when the initial letter is invalid' do
        let(:number) { '58150668!898' }
        it 'returns the correct error message' do
          civil_number.valid?
          expect(civil_number.error).to eq('Invalid letter')
        end
      end
    end
  end

  describe '#check_control_sum_steuer_idnr' do
    let(:is_rvnr) { false }

    context 'when control number coincides with count number' do
      let(:number) { '33309240064' }
      it { expect(civil_number.send(:check_control_sum_steuer_idnr)).to eq(true) }
    end

    context 'when control number does not coincide with count number' do
      let(:number) { '33309240063' }
      it { expect(civil_number.send(:check_control_sum_steuer_idnr)).to eq(false) }
    end

    context 'validates 2015-tax-id correctly' do
      let(:number) { '12345678995' }
      it { expect(civil_number.send(:check_control_sum_steuer_idnr)).to eq(true) }
    end

    context 'invalidates incorrect 2015-tax-id' do
      let(:number) { '12346678995' }
      it { expect(civil_number.send(:check_control_sum_steuer_idnr)).to eq(false) }
    end

    context 'validates 2016-tax-id correctly' do
      let(:number) { '12345679998' }
      it { expect(civil_number.send(:check_control_sum_steuer_idnr)).to eq(true) }
    end

    context 'invalidates incorrect 2016-tax-id' do
      let(:number) { '12335679998' }
      it { expect(civil_number.send(:check_control_sum_steuer_idnr)).to eq(false) }
    end
  end

  describe '#check_control_sum_rvnr' do
    let(:is_rvnr) { true }

    context 'when control sum is correct' do
      it 'checks control sum for multiple valid numbers' do
        valid_numbers = %w[58260201H633 66010576O780 24160324W604]
        valid_numbers.each do |number|
          civil_number = described_class.new(number, true)
          expect(civil_number.send(:check_control_sum_rvnr)).to eq(true)
        end
      end
    end

    context 'when control sum is incorrect' do
      it 'checks control sum for multiple invalid numbers' do
        invalid_numbers = %w[58260201H634 66010576O781 24160324W605]
        invalid_numbers.each do |number|
          civil_number = described_class.new(number, true)
          expect(civil_number.send(:check_control_sum_rvnr)).to eq(false)
        end
      end
    end
  end

  describe '#count_last_number' do
    let(:is_rvnr) { false }
    let(:number) { '56214987054' }
    it { expect(civil_number.send(:count_last_number)).to eq(4) }
  end
end
