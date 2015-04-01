class UsersHistories < ApplicationModel
  belongs_to :user
  belongs_to :disease

  validates :history_type, text: true, presence: true
end
