module LayoutHelper
  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def display_var(v)
    var = v.variable
    case var.value_type
    when 'percent'
      number_to_percentage(v.value*100)
    when 'float'
      (number_with_precision(v.value, precision: var.precision) + " #{var.unit}") unless v.nil?
    when 'integer'
      (number_with_precision(v.value, precision: 0) + " #{var.unit}") unless v.nil?
   end
  end

  def bmi_level(bmi_var)
    bmi = bmi_var.value
    if (bmi < 18.5)
      'underweight'
    elsif (bmi < 25)
      'normal'
    elsif (bmi < 30)
      'overweight'
    else
      'obese'
    end
  end

  def track_rec(user)
    rec = nil
    risk_level = 0
    if (user.bmi.value >= 25)
      rec = '"Manage weight"'
    else
      if user.hbp_risk.present?
        rec = '"Decrease high blood pressure risk"'
        risk_level = user.hbp_risk.value
      end
      if (user.cvd_risk.present? && user.cvd_risk.value > risk_level)
        rec = '"Decrease heart disease risk"'
        risk_level = @user.cvd_risk.value
      end
      if (user.diabetes_risk.present? && user.diabetes_risk.value > risk_level)
        rec = '"Decrease diabetes risk"'
        risk_level = user.diabetes_risk.value
      end
    end
    rec
  end
end
