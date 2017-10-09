# GroupEventForm deals with validation for GroupEvent,
# so the model itself remains clean
class GroupEventForm < FormObject
  attr_accessor :state,
                :end_date,
                :start_date,
                :duration,
                :name,
                :description,
                :location,
                :user_id

  validates :user_id, presence: true
  validate :validate_if_state_published
  validate :validate_start_date_format
  validate :validate_end_date_format
  validate :sort_out_dates

  def create_new_group_event
    create_group_event if valid?
  end

  def update_group_event(event)
    update_event(event) if valid?
  end

  private

  def create_group_event
    GroupEvent.create(
      user_id: user_id,
      name: name,
      description: description,
      location: location,
      start_date: start_date,
      end_date: end_date,
      duration: duration
    )
  end

  def update_event(event)
    event.update(
      name: name,
      description: description,
      location: location,
      state: state,
      start_date: start_date,
      end_date: end_date,
      duration: duration
    )
  end

  def validate_end_date_format
    begin
      Date.parse(end_date.to_s) if end_date.present?
    rescue ArgumentError
      errors.add(
        :end_date,
        'is not of valid format'
      )
    end
  end

  def validate_start_date_format
    begin
      Date.parse(start_date.to_s) if start_date.present?
    rescue ArgumentError
      errors.add(
        :start_date,
        'is not of valid format'
      )
    end
  end

  def validate_if_state_published
    if state && state == 'published'
      validate_if_dates_present
      validate_other_data
    end
  end

  def sort_out_dates
    if errors.empty?
      if start_date.present? && end_date.present?
        calculate_duration
      else
        calculate_dates
      end
    end
  end

  def calculate_duration
    if start_date.to_datetime > end_date.to_datetime
      errors.add(:end_date, 'must be larger than the start date')
    else
      @duration = (end_date.to_datetime - start_date.to_datetime).to_i
    end
  end

  def calculate_dates
    if start_date.present? && duration.present?
      @end_date = start_date.to_datetime + duration.to_i.days
    elsif end_date.present? && duration.present?
      @start_date = end_date.to_datetime - duration.to_i.days
    end
  end

  def validate_if_dates_present
    unless (end_date.present? && start_date.present?) ||
           (duration.present? && start_date.present?) ||
           (duration.present? && end_date.present?)
      errors.add(
        :duration,
        'You must select two of three options for duration of Event'
      )
    end
  end

  def validate_other_data
    unless name.present? && description.present? && location.present?
      errors.add(:name, 'must be present')
      errors.add(:description, 'must be present')
      errors.add(:location, 'must be present')
    end
  end
end
