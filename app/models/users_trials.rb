class UsersTrials < ActiveRecord::Base
  belongs_to :user
  belongs_to :trial
end
