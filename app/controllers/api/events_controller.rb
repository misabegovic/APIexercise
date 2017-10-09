module Api
  # EventsController, deals with api requests for events
  class EventsController < ApiController
    before_action :set_event, only: [:show, :edit, :update, :destroy]

    def index
      @events = GroupEvent.all.where(deleted: false)
      render json: @events
    end

    def show
      render json: @event
    end

    def create
      @event_form = GroupEventForm.new(group_event_params)

      if @event_form.create_new_group_event
        render json: @event_form, status: :created
      else
        render_error(@event_form, :unprocessable_entity)
      end
    end

    def edit
      render json: GroupEventForm.new(@event.attributes)
    end

    def update
      @event_form = GroupEventForm.new(group_event_params)

      if @event_form.update_group_event(@event)
        render json: @event, status: :ok
      else
        render_error(@event_form, :unprocessable_entity)
      end
    end

    def destroy
      @event.deleted = true
      @event.save

      render json: @event
    end

    private

    def set_event
      begin
        @event = GroupEvent.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        event = GroupEvent.new
        event.errors.add(:id, 'Wrong ID provided')
        render_error(event, 404) && return
      end
    end

    def group_event_params
      params.require(:group_event_form).permit(
        :name,
        :location,
        :description,
        :start_date,
        :end_date,
        :duration,
        :state,
        :user_id
      )
    end
  end
end
