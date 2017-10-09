require 'rails_helper'

RSpec.describe GroupEvent, type: :model do
  before { create(:user, :valid) }

  it 'has a valid factory' do
    expect(build(:group_event)).to be_valid
  end
end
