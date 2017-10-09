# Serializer for User model
class UserSerializer < ActiveModel::Serializer
  attributes :id, :username

  has_many :group_events
end
