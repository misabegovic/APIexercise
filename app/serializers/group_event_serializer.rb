# Serializer for GroupEvent model
class GroupEventSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :location,
             :start_date, :end_date, :state, :deleted
  belongs_to :user
end
