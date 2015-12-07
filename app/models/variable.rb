class Variable < ApplicationModel
  validates :variable_type, text: true
  validates :name, text: true, :null => false
  validates :unit, text: true
  validates :precision, integer: true, :null => false, :default => 0
  validates :value_type, text: true, :null => false
  validates :low, text: true
  validates :high, text: true
  validates :ideal, text: true

  has_many :diseases, :through => :variables_diseases
end
