module ProfilesHelper
  def options_for_height
    (55..82).collect do |o|
      divmod_output = o.divmod(12)
      ["#{divmod_output[0]} ft, #{divmod_output[1]} in", o]
    end
  end

  def options_for_weight
    (70..440).collect do |o|
      ["#{o} lbs", o]
    end
  end

  def options_for_waist_circumference
    (19..69).collect do |o|
      ["#{o} in", o]
    end
  end

  def options_for_hip_circumference
    (31..79).collect do |o|
      ["#{o} in", o]
    end
  end
  
  def options_for_systolic_blood_pressure
    (50..232).collect do |o|
      ["#{o}", o]
    end
  end

  def options_for_diastolic_blood_pressure
    (30..140).collect do |o|
      ["#{o}", o]
    end
  end

  def options_for_blood_sugar
    (63..333).collect do |o|
      ["#{o}", o]
    end
  end

  def options_for_hemoglobin_a1c
    (35..150).collect do |o|
      ["#{o/10.0}", o/10.0]
    end
  end

  def options_for_total_cholesterol
    (41..584).collect do |o|
      ["#{o}", o]
    end
  end

  def options_for_hdl_cholesterol
    (5..100).collect do |o|
      ["#{o}", o]
    end
  end

  def options_for_triglycerides
    (10..614).collect do |o|
      ["#{o}", o]
    end
  end

  def display_intervention_treatments(s, tracks)
    if tracks.nil?
      treatments = s.diseases.map(&:name).map(&:humanize)
    else
      treatments = (s.diseases.map(&:name) & tracks.map(&:disease).map(&:name)).map(&:humanize)
    end

    if treatments.blank?
      return ''
    else
      "(" + treatments.join(', ') + ")"
    end
  end

  def display_intervention_contraindications(s)
    if s.contraindications.blank?
      return ''
    else
      "WARNING: Do not select if you have " + s.contraindications.map(&:name).map(&:humanize).join(', ')
    end
  end

  def ethnicity_options
    [
      ['East Asian or Asian American','asian'],
      ['South Asian or Indian American','indian'],
      ['Middle Eastern or Arab American','middleeastern'],
      ['Black, Afro-Caribbean, or African American','black'],
      ['Latino or Hispanic American','hispanic'],
      ['Native American or Alaskan Native','alaskan'],
      ['Non-Hispanic White or Euro-American','white'],
      ['Other','other']
    ]
  end
end
