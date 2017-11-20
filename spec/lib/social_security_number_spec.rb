require 'spec_helper'

RSpec.describe 'subject' do
  it 'has a version number' do
    expect(SocialSecurityNumber::VERSION).not_to be nil
  end
end
