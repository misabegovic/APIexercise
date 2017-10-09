# User model
class User < ApplicationRecord
  has_secure_token
  has_secure_password
  has_many :group_events, dependent: :destroy
end
