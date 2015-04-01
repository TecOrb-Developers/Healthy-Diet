# An intervention is another name of a supplement.  Name, description.  Only show relations into 
# A contraindication is a disease for which a particlar supplement which makes a disease work. ???
# Ex: lowering blood pressure.  

class Intervention < ApplicationModel
  belongs_to :principle

  mount_uploader :image, ImageUploader
  # TBD: before_create :default_name
  # TBD: mount_uploader :image, ImageUploader

  # belongs_to :intervention_type  not needed.  use principle_id == null for extra
  # has_many :tracks, through :diseases # ADD??

  validates :name, text: true, presence: true
  # validates :description, text: true   # Mike says: description is now in more specific content fields
  # t.string :name, index: true, null: false
  # t.references :intervention_type, null: false #, index: true  # This isn't needed.  Basic if principle_id is not null.
  # t.string :title
  # t.string :abbrev
  # t.text :benefit
  # t.string :tracks  # SHOULD BE DELETED
  # t.text :regimen
  # t.text :alternate_options
  # t.text :maintenance_dose
  # t.text :safety_precautions
  # t.string :image
  has_many :tracks

  has_many :diseases, :through => :interventions_diseases
  has_many :interventions_diseases, :class_name => InterventionsDiseases
  has_many :contraindications, :through => :interventions_contraindications, :source => :disease
  has_many :interventions_contraindications, :class_name => InterventionsContraindications

  has_many :intervention_trials

  def disease_names
    self.diseases.map(&:name)
  end

  def contraindication_names
    self.contraindications.map(&:name)
  end

  def self.disease(disease_array)
    disease_array = [disease_array] unless disease_array.is_a?(Array)
    Intervention.joins(:diseases).where("diseases.id IN (?)", disease_array.map(&:id)).uniq
  end

  def self.contraindication(disease_array)
    disease_array = [disease_array] unless disease_array.is_a?(Array)
    Intervention.joins(:contraindications).where("diseases.id IN (?)", disease_array.map(&:id)).uniq
  end

  def self.treatment(disease_array)
    disease(disease_array) - contraindication(disease_array)
  end

  private

  def default_name
    self.name ||= File.basename(image.filename, '.*').titleize if image
  end

end

