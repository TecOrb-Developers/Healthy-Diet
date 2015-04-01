class InterventionType < ApplicationModel
  validates :name, text: true, presence: true

  has_many :interventions
end
