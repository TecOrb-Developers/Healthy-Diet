class Principle < ActiveRecord::Base
  include ValidationHelper

  has_many :interventions

end
