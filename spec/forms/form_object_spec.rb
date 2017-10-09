require 'rails_helper'

RSpec.describe FormObject do
  before { create(:user, :valid) }

  describe 'has valid initialziation' do
    it do
      @form_object = FormObject.new(test: 'Test')
    end

    after do
      expect(@form_object.class).to eql FormObject
      expect(@form_object.instance_variables).to eql [:@test]
    end
  end
end
