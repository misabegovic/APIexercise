# Event model
class GroupEvent < ApplicationRecord
  belongs_to :user
  enum state: [:draft, :published]
end
