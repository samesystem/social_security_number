# frozen_string_literal: true

require 'spec_helper'

describe SocialSecurityNumber::De2 do
  subject(:civil_number) { SocialSecurityNumber::De2.new(number) }

  describe '#validate' do
    let(:number) { '58150668G898' }

    context 'when the number is valid' do
      it { is_expected.to be_valid }
    end
  end

  describe '#error' do
    subject(:error) { civil_number.tap(&:valid?).error }

    context 'when full number length is invalid' do
      let(:number) { '58150668G8982' }
      it { is_expected.to eq('number should be length of 12') }
    end

    context 'when the area number is invalid' do
      let(:number) { '62150668G898' }
      it { is_expected.to eq('invalid area number') }
    end

    context 'when the birth date is invalid' do
      let(:number) { '58151668G898' }
      it { is_expected.to eq('invalid date of birth') }
    end

    context 'when the initial letter is invalid' do
      let(:number) { '58150668!898' }
      it { is_expected.to eq('Invalid letter') }
    end
  end

  describe '#check_control_sum' do
    context 'when control sum is correct' do
      let(:valid_numbers) { %w[58260201H633 66010576O780 24160324W604] }

      it 'checks control sum for multiple numbers' do
        valid_numbers.each do |number|
          civil_number = SocialSecurityNumber::De2.new(number)
          expect(civil_number.send(:check_control_sum)).to eq(true)
        end
      end
    end

    context 'when control sum is incorrect' do
      let(:invalid_numbers) { %w[58260201H634 66010576O781 24160324W605] }

      it 'checks control sum for multiple numbers' do
        invalid_numbers.each do |number|
          civil_number = SocialSecurityNumber::De2.new(number)
          expect(civil_number.send(:check_control_sum)).to eq(false)
        end
      end
    end
  end
end
