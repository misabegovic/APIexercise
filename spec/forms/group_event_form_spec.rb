require 'rails_helper'

RSpec.describe GroupEventForm do
  before { create(:user, :valid) }

  describe 'has valid initialziation' do
    it do
      @params = attributes_for(:group_event, :valid)

      @group_event_form = GroupEventForm.new(@params)
    end

    after do
      expect(@group_event_form.class).to eql GroupEventForm
      expect(@group_event_form.instance_variables).to eql [
        :@user_id,
        :@start_date,
        :@end_date,
        :@duration,
        :@name,
        :@description,
        :@location
      ]
      expect(@group_event_form.user_id).to eql @params[:user_id]
      expect(@group_event_form.location).to eql @params[:location]
      expect(@group_event_form.start_date).to eql @params[:start_date]
      expect(@group_event_form.end_date).to eql @params[:end_date]
      expect(@group_event_form.duration).to eql @params[:duration]
      expect(@group_event_form.name).to eql @params[:name]
      expect(@group_event_form.description).to eql @params[:description]
    end
  end

  describe 'creates new group_event' do
    it do
      @params = attributes_for(:group_event, :valid)

      @group_event_form = GroupEventForm.new(@params)
      @group_event_form.create_new_group_event
    end

    it do
      @params = attributes_for(:group_event, :with_duration_and_start_date)

      @group_event_form = GroupEventForm.new(@params)
      @group_event_form.create_new_group_event
    end

    it do
      @params = attributes_for(:group_event, :with_duration_and_end_date)

      @group_event_form = GroupEventForm.new(@params)
      @group_event_form.create_new_group_event
    end

    after do
      group_event = GroupEvent.first

      expect(group_event.state).to eql 'draft'
      expect(group_event.deleted).to eql false
      expect(@group_event_form.user_id).to eql group_event.user_id
      expect(@group_event_form.location).to eql group_event.location
      expect(@group_event_form.name).to eql group_event.name
      expect(@group_event_form.description).to eql group_event.description
      expect(@group_event_form.duration).to eql group_event.duration
      expect(@group_event_form.end_date).to be_between(
        group_event.start_date.to_date,
        group_event.start_date.to_date + group_event.duration.days
      )
      expect(@group_event_form.start_date).to be_between(
        group_event.end_date.to_date - group_event.duration.days,
        group_event.end_date.to_date
      )
    end
  end

  describe 'fails to create new group_event, user_id is blank' do
    it do
      @group_event_form = GroupEventForm.new
      @group_event_form.create_new_group_event
    end

    after do
      group_event = GroupEvent.first

      expect(group_event).to eql nil
      expect(@group_event_form.errors.full_messages.length).to eql 1
      expect(@group_event_form.errors.full_messages[0]).to eql(
        "User can't be blank"
      )
    end
  end

  describe 'fails to create new group_event, no data' do
    it do
      @group_event_form = GroupEventForm.new(user_id: 1, state: 'published')
      @group_event_form.create_new_group_event
    end

    after do
      group_event = GroupEvent.first

      expect(group_event).to eql nil
      expect(@group_event_form.errors.full_messages.length).to eql 4
      expect(@group_event_form.errors.full_messages[0]).to eql(
        'Duration You must select two of three options for duration of Event'
      )
      expect(@group_event_form.errors.full_messages[1]).to eql(
        'Name must be present'
      )
      expect(@group_event_form.errors.full_messages[2]).to eql(
        'Description must be present'
      )
      expect(@group_event_form.errors.full_messages[3]).to eql(
        'Location must be present'
      )
    end
  end

  describe 'fails to create new group_event, invalid dates' do
    it do
      @params = attributes_for(:group_event, :invalid_dates)

      @group_event_form = GroupEventForm.new(@params)
      @group_event_form.create_new_group_event
    end

    after do
      group_event = GroupEvent.first

      expect(group_event).to eql nil
      expect(@group_event_form.errors.full_messages.first).to eql(
        'End date must be larger than the start date'
      )
    end
  end

  describe 'fails to create new group_event, invalid date input' do
    it do
      @params = attributes_for(
        :group_event,
        start_date: 'TestA',
        end_date: 'TestB',
        duration: 50
      )

      @group_event_form = GroupEventForm.new(@params)
      @group_event_form.create_new_group_event
      expect(@group_event_form.errors.full_messages).to eql(
        [
          'Start date is not of valid format',
          'End date is not of valid format'
        ]
      )
    end

    it do
      @params = attributes_for(
        :group_event,
        end_date: 'TestB',
        duration: 50
      )

      @group_event_form = GroupEventForm.new(@params)
      @group_event_form.create_new_group_event
      expect(@group_event_form.errors.full_messages).to eql(
        ['End date is not of valid format']
      )
    end

    it do
      @params = attributes_for(
        :group_event,
        start_date: 'TestA',
        duration: 50
      )

      @group_event_form = GroupEventForm.new(@params)
      @group_event_form.create_new_group_event
      expect(@group_event_form.errors.full_messages).to eql(
        ['Start date is not of valid format']
      )
    end

    after do
      group_event = GroupEvent.first

      expect(group_event).to eql nil
    end
  end

  describe 'updates group_event' do
    it do
      @event = create(:group_event, :valid)
      @event.state = 'published'

      @group_event_form = GroupEventForm.new(@event.attributes)
      @group_event_form.update_group_event(@event)
    end

    after do
      group_event = GroupEvent.first

      expect(group_event.state).to eql 'published'
    end
  end

  describe 'fails to update group_event' do
    it do
      @event = create(:group_event, :valid)

      @group_event_form = GroupEventForm.new(state: 'published')
      @group_event_form.update_group_event(@event)
    end

    after do
      expect(@event.state).to eql 'draft'
      expect(@group_event_form.errors.full_messages.length).to eql 5
      expect(@group_event_form.errors.full_messages[0]).to eql(
        "User can't be blank"
      )
      expect(@group_event_form.errors.full_messages[1]).to eql(
        'Duration You must select two of three options for duration of Event'
      )
      expect(@group_event_form.errors.full_messages[2]).to eql(
        'Name must be present'
      )
      expect(@group_event_form.errors.full_messages[3]).to eql(
        'Description must be present'
      )
      expect(@group_event_form.errors.full_messages[4]).to eql(
        'Location must be present'
      )
    end
  end
end
