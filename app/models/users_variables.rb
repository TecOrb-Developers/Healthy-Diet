class UsersVariables < ApplicationModel
  belongs_to :user
  belongs_to :variable

  validates :value, float: true, presence: true
  validates :value2, float: true
end
