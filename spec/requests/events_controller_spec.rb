require 'rails_helper'

RSpec.describe Api::EventsController, type: :request do
  before do
    @user = create(:user, :valid)

    9.times do
      create(:group_event)
    end

    @event = create(:group_event)
  end

  describe 'index' do
    it { get '/api/events' }

    after do
      jdata = JSON.parse response.body

      assert_response :success
      assert_equal 10, jdata.length
    end
  end

  describe 'edit' do
    it { get '/api/events/10/edit' }

    after do
      jdata = JSON.parse response.body

      assert_response :success
      assert_equal @event.id, jdata['id']
    end
  end

  describe 'Should get valid event data' do
    it { get '/api/events/10' }

    after do
      jdata = JSON.parse response.body

      assert_response :success
      assert_equal @user.id, jdata['user']['id']
      assert_equal @event.id, jdata['id']
    end
  end

  describe 'Should get invalid event data' do
    it { get '/api/events/13' }

    after do
      jdata = JSON.parse response.body

      assert_response :not_found
      assert_equal 'Wrong ID provided', jdata['errors'][0]['detail']
    end
  end

  describe 'Creating new event with incorrect params' do
    it do
      post '/api/events', params: {
        group_event_form: {
          user_id: ''
        }
      }
    end

    after do
      jdata = JSON.parse response.body

      assert_response :unprocessable_entity
      assert_equal "can't be blank", jdata['errors'][0]['detail']
    end
  end

  describe 'Creating new event with sending correct params' do
    it do
      post '/api/events', params: {
        group_event_form: {
          name: 'a',
          user_id: 1
        }
      }
    end

    after do
      jdata = JSON.parse response.body

      assert_response :created
      assert_equal 'a', jdata['name']
    end
  end

  describe 'Creating new event with start_date > end_date' do
    it do
      post '/api/events', params: {
        group_event_form: {
          start_date: Date.today + 50.days,
          end_date: Date.today,
          user_id: 1
        }
      }
    end

    after do
      jdata = JSON.parse response.body

      assert_response :unprocessable_entity
      assert_equal 'must be larger than the start date',
                   jdata['errors'][0]['detail']
    end
  end

  describe 'Creating new event with valid dates' do
    it do
      post '/api/events', params: {
        group_event_form: {
          duration: 50,
          start_date: Date.today,
          user_id: 1
        }
      }
    end

    it do
      post '/api/events', params: {
        group_event_form: {
          duration: 50,
          end_date: Date.today + 50.days,
          user_id: 1
        }
      }
    end

    it do
      post '/api/events', params: {
        group_event_form: {
          end_date: Time.now + 50.days,
          start_date: Time.now,
          user_id: 1
        }
      }
    end

    after do
      assert_response :created
    end
  end

  describe 'Updating name with sending correct params' do
    it do
      patch '/api/events/1', params: {
        group_event_form: {
          user_id: 1,
          name: 'changed'
        }
      }
    end

    after do
      jdata = JSON.parse response.body

      assert_equal 'changed', jdata['name']
    end
  end

  describe 'Updating state with sending correct params' do
    it do
      patch '/api/events/1', params: {
        group_event_form: {
          user_id: 1,
          state: 'published'
        }
      }
    end

    after do
      jdata = JSON.parse response.body

      assert_equal 'You must select two of three options for duration of Event',
                   jdata['errors'][0]['detail']
    end
  end

  describe 'Deleting event with sending correct params should result in 204' do
    it { delete '/api/events/1' }

    after do
      jdata = JSON.parse response.body

      assert_equal true, jdata['deleted']
    end
  end
end
