require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(build(:user, :valid)).to be_valid
  end

  it 'is invalid without password' do
    expect(build(:user, :invalid)).not_to be_valid
  end
end
