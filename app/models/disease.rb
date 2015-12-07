class Disease < ApplicationModel
  has_many :interventions, :through => :interventions_diseases
  has_many :variables, :through => :variables_diseases

  validates :track_history, boolean: true
  validates :track_medicine, boolean: true

  def self.history
    where(:track_history => true)
  end

  def self.medicine
    where(:track_medicine => true)
  end
end
