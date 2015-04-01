# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
obesity = Disease.create([{ :name => 'obesity', :track_history => false, :track_medicine => false }]).first
diabetes = Disease.create([{ :name => 'diabetes', :track_history => true, :track_medicine => true }]).first
hbp = Disease.create([{ :name => 'high_blood_pressure', :track_history => true, :track_medicine => true }]).first
hd = Disease.create([{ :name => 'heart_disease', :track_history => true, :track_medicine => true }]).first
stroke = Disease.create([{ :name => 'stroke', :track_history => false, :track_medicine => false }]).first
kd = Disease.create([{ :name => 'kidney_disease', :track_history => false, :track_medicine => false }]).first

Variable.create([{ :variable_type => 'covariable', :name => 'exercise_level', :value_type => 'boolean', :ideal => 1}])
Variable.create([{ :variable_type => 'covariable', :name => 'smoke', :value_type => 'boolean', :ideal => 0 }])
Variable.create([{ :variable_type => 'covariable', :name => 'alcohol', :value_type => 'boolean', :ideal => 0 }])
Variable.create([{ :variable_type => 'decision', :name => 'hbp_risk', :value_type => 'percent' }])
Variable.create([{ :variable_type => 'decision', :name => 'cvd_risk', :value_type => 'percent' }])
Variable.create([{ :variable_type => 'decision', :name => 'diabetes_risk', :value_type => 'percent' }])
Variable.create([{ :variable_type => 'decision', :name => 'bmi', :unit => 'kg/m^2', :value_type => 'integer' }])
Variable.create([{ :variable_type => 'treatment', :name => 'weight', :unit => 'lbs', :value_type => 'integer' }])
Variable.create([{ :variable_type => 'treatment', :name => 'goal_weight', :unit => 'lbs', :value_type => 'integer' }])
Variable.create([{ :variable_type => 'treatment', :name => 'height', :unit => 'inches', :value_type => 'integer' }])
Variable.create([{ :variable_type => 'treatment', :name => 'waist_circumference', :unit => 'inches', :value_type => 'integer' }])
Variable.create([{ :variable_type => 'treatment', :name => 'hip_circumference', :unit => 'inches', :value_type => 'integer' }])
Variable.create([{ :variable_type => 'treatment', :name => 'blood_pressure',:value_type => 'fraction' }])
Variable.create([{ :variable_type => 'treatment', :name => 'blood_sugar', :value_type => 'integer' }])
Variable.create([{ :variable_type => 'treatment', :name => 'hemoglobin_A1C', :value_type => 'float', :precision => 1 }])
Variable.create([{ :variable_type => 'treatment', :name => 'total_cholesterol', :unit => 'mg/dl', :value_type => 'integer' }])
Variable.create([{ :variable_type => 'treatment', :name => 'hdl_cholesterol', :unit => 'mg/dl', :value_type => 'integer' }])
Variable.create([{ :variable_type => 'treatment', :name => 'triglycerides', :unit => 'mg/dl', :value_type => 'integer' }])

#basic = InterventionType.create([{ :name => 'basic' }]).first  # def intervention_type_extra? principles.empty? end
#xtra = InterventionType.create([{ :name => 'xtra' }]).first

konjac = Intervention.create([{ :name => 'konjac_fiber'}]).first
  # Alt syntax: konjac = basic.interventions.create({name: 'konjac_fiber'})
olive_oil = Intervention.create([{ :name => 'extra_light_olive_oil'}]).first
vinegar = Intervention.create([{ :name => 'apple_cider_vinegar'}]).first
cinnamon = Intervention.create([{ :name => 'cinnamon'}]).first
wine = Intervention.create([{ :name => 'red_wine'}]).first
pepper = Intervention.create([{ :name => 'capsaicin'}]).first
soup = Intervention.create([{ :name => 'smooth_tomato_soup'}]).first
water = Intervention.create([{ :name => 'water'}]).first
pine_oil = Intervention.create([{ :name => 'korean_pine_nut_oil'}]).first
safflower_oil = Intervention.create([{ :name => 'safflower_oil'}]).first
ygd = Intervention.create([{ :name => 'YGD'}]).first
griffonia = Intervention.create([{ :name => 'griffonia_simplicifolia'}]).first
tamarind = Intervention.create([{ :name => 'malabar_tamarind'}]).first
chia = Intervention.create([{ :name => '?chia'}]).first
chocolate = Intervention.create([{ :name => 'cocoa'}]).first
garlic = Intervention.create([{ :name => 'garlic'}]).first
walnut = Intervention.create([{ :name => 'walnuts'}]).first
blueberry = Intervention.create([{ :name => 'blueberry'}]).first
beet = Intervention.create([{ :name => 'beet'}]).first
grapefruit = Intervention.create([{ :name => 'grapefruit'}]).first
green_tea = Intervention.create([{ :name => 'green_tea'}]).first
grape_juice = Intervention.create([{ :name => 'grape_juice'}]).first
cod_oil = Intervention.create([{ :name => 'cod_oil'}]).first
chromium = Intervention.create([{ :name => 'chromium'}]).first
pomegranate = Intervention.create([{ :name => 'pomegranate_juice'}]).first
magnesium = Intervention.create([{ :name => 'magnesium'}]).first
soy = Intervention.create([{ :name => 'soy'}]).first
fish = Intervention.create([{ :name => 'fish'}]).first
potassium = Intervention.create([{ :name => 'potassium'}]).first

# Alt syntax: obesity.interventions.create([{intervention: konjac}, {intervention: olive_oil}])
InterventionsDiseases.create([{ :intervention_id => konjac.id, :disease_id => obesity.id }])
InterventionsDiseases.create([{ :intervention_id => konjac.id, :disease_id => diabetes.id }])
InterventionsDiseases.create([{ :intervention_id => konjac.id, :disease_id => hd.id }])
InterventionsDiseases.create([{ :intervention_id => olive_oil.id, :disease_id => obesity.id }])
InterventionsDiseases.create([{ :intervention_id => olive_oil.id, :disease_id => hbp.id }])
InterventionsDiseases.create([{ :intervention_id => olive_oil.id, :disease_id => hd.id }])
InterventionsDiseases.create([{ :intervention_id => vinegar.id, :disease_id => obesity.id }])
InterventionsDiseases.create([{ :intervention_id => vinegar.id, :disease_id => diabetes.id }])
InterventionsDiseases.create([{ :intervention_id => cinnamon.id, :disease_id => obesity.id }])
InterventionsDiseases.create([{ :intervention_id => cinnamon.id, :disease_id => diabetes.id }])
InterventionsDiseases.create([{ :intervention_id => cinnamon.id, :disease_id => hd.id }])
InterventionsDiseases.create([{ :intervention_id => wine.id, :disease_id => obesity.id }])
InterventionsDiseases.create([{ :intervention_id => wine.id, :disease_id => diabetes.id }])
InterventionsDiseases.create([{ :intervention_id => wine.id, :disease_id => hd.id }])
InterventionsDiseases.create([{ :intervention_id => pepper.id, :disease_id => obesity.id }])
InterventionsDiseases.create([{ :intervention_id => pepper.id, :disease_id => diabetes.id }])
InterventionsDiseases.create([{ :intervention_id => pepper.id, :disease_id => hd.id }])
InterventionsDiseases.create([{ :intervention_id => soup.id, :disease_id => obesity.id }])
InterventionsDiseases.create([{ :intervention_id => water.id, :disease_id => obesity.id }])
InterventionsDiseases.create([{ :intervention_id => pine_oil.id, :disease_id => obesity.id }])
InterventionsDiseases.create([{ :intervention_id => safflower_oil.id, :disease_id => obesity.id }])
InterventionsDiseases.create([{ :intervention_id => ygd.id, :disease_id => obesity.id }])
InterventionsDiseases.create([{ :intervention_id => griffonia.id, :disease_id => obesity.id }])
InterventionsDiseases.create([{ :intervention_id => tamarind.id, :disease_id => obesity.id }])

InterventionsDiseases.create([{ :intervention_id => chia.id, :disease_id => diabetes.id }])
InterventionsDiseases.create([{ :intervention_id => chia.id, :disease_id => hbp.id }])
InterventionsDiseases.create([{ :intervention_id => chia.id, :disease_id => hd.id }])
InterventionsDiseases.create([{ :intervention_id => chocolate.id, :disease_id => diabetes.id }])
InterventionsDiseases.create([{ :intervention_id => chocolate.id, :disease_id => hbp.id }])
InterventionsDiseases.create([{ :intervention_id => chocolate.id, :disease_id => hd.id }])
InterventionsDiseases.create([{ :intervention_id => garlic.id, :disease_id => diabetes.id }])
InterventionsDiseases.create([{ :intervention_id => garlic.id, :disease_id => hbp.id }])
InterventionsDiseases.create([{ :intervention_id => garlic.id, :disease_id => hd.id }])
InterventionsDiseases.create([{ :intervention_id => walnut.id, :disease_id => diabetes.id }])
InterventionsDiseases.create([{ :intervention_id => walnut.id, :disease_id => hbp.id }])
InterventionsDiseases.create([{ :intervention_id => walnut.id, :disease_id => hd.id }])
InterventionsDiseases.create([{ :intervention_id => blueberry.id, :disease_id => diabetes.id }])
InterventionsDiseases.create([{ :intervention_id => blueberry.id, :disease_id => hbp.id }])
InterventionsDiseases.create([{ :intervention_id => blueberry.id, :disease_id => hd.id }])
InterventionsDiseases.create([{ :intervention_id => beet.id, :disease_id => hbp.id }])
InterventionsDiseases.create([{ :intervention_id => grapefruit.id, :disease_id => hbp.id }])
InterventionsDiseases.create([{ :intervention_id => grapefruit.id, :disease_id => hd.id }])
InterventionsDiseases.create([{ :intervention_id => green_tea.id, :disease_id => hd.id }])
InterventionsDiseases.create([{ :intervention_id => grape_juice.id, :disease_id => hbp.id }])
InterventionsDiseases.create([{ :intervention_id => grape_juice.id, :disease_id => hd.id }])
InterventionsDiseases.create([{ :intervention_id => cod_oil.id, :disease_id => obesity.id }])
InterventionsDiseases.create([{ :intervention_id => cod_oil.id, :disease_id => hbp.id }])
InterventionsDiseases.create([{ :intervention_id => chromium.id, :disease_id => diabetes.id }])
InterventionsDiseases.create([{ :intervention_id => chromium.id, :disease_id => diabetes.id }])
InterventionsDiseases.create([{ :intervention_id => pomegranate.id, :disease_id => hbp.id }])
InterventionsDiseases.create([{ :intervention_id => pomegranate.id, :disease_id => hd.id }])
InterventionsDiseases.create([{ :intervention_id => magnesium.id, :disease_id => hd.id }])
InterventionsDiseases.create([{ :intervention_id => magnesium.id, :disease_id => hbp.id }])
InterventionsDiseases.create([{ :intervention_id => soy.id, :disease_id => hbp.id }])
InterventionsDiseases.create([{ :intervention_id => soy.id, :disease_id => hd.id }])
InterventionsDiseases.create([{ :intervention_id => fish.id, :disease_id => hbp.id }])
InterventionsDiseases.create([{ :intervention_id => fish.id, :disease_id => hd.id }])
InterventionsDiseases.create([{ :intervention_id => potassium.id, :disease_id => hbp.id }])

InterventionsContraindications.create([{ :intervention_id => wine.id, :disease_id => hbp.id }])
InterventionsContraindications.create([{ :intervention_id => pepper.id, :disease_id => hbp.id }])
InterventionsContraindications.create([{ :intervention_id => safflower_oil.id, :disease_id => hd.id }])
InterventionsContraindications.create([{ :intervention_id => green_tea.id, :disease_id => hbp.id }])
InterventionsContraindications.create([{ :intervention_id => grape_juice.id, :disease_id => diabetes.id }])

Track.create([{ :name => 'manage_weight', :disease_id => obesity.id }])
Track.create([{ :name => 'decrease_diabetes_risk', :disease_id => diabetes.id }])
Track.create([{ :name => 'decrease_high_blood_pressure_risk', :disease_id => hbp.id }])
Track.create([{ :name => 'decrease_heart_disease_risk', :disease_id => hd.id }])


