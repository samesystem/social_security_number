require 'spec_helper'

RSpec.describe 'subject' do
  it "has a version number" do
    expect(CivilNumber::VERSION).not_to be nil
  end
end
