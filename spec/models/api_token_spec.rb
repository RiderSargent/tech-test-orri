require 'rails_helper'

RSpec.describe ApiToken, type: :model do
  before(:each) do
    ApiToken.create(name: 'github', token: 'abc123')
  end

  context '#token' do
    it 'returns the token value for a named API token' do
      expect(ApiToken.find_by(name: 'github').token).to eq('abc123')
    end
  end
end
