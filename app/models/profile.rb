class Profile < ActiveRecord::Base
  include ValidationHelper

  belongs_to :user
end
