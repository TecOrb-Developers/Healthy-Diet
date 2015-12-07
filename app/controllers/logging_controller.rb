class LoggingController < ApplicationController
  before_action :authenticate_user!

  def create
    params[:daily_log].each do |k,v|
      InterventionUse.where(:intervention_trial_id => k.to_i, :on_date => Time.zone.now.to_date, :taken => v).first_or_create
    end if params[:daily_log].present?
    redirect_to dashboard_index_path
  end

  def update
    if params[:update_log].present?
      params[:update_log].each do |k,v|
        iu = InterventionUse.find_by_intervention_trial_id_and_on_date(k.to_i, params[:on_date])
        iu.destroy if iu.present?
        InterventionUse.where(:intervention_trial_id => k.to_i, :on_date => params[:on_date], :taken => v).first_or_create
      end
      flash[:notice] = "Log updated"
      redirect_to dashboard_index_path
    end
    @logging_date = (current_user.trials.active.first.start_date + (params[:id].to_i - 1).days)
    @current_count = params[:id].to_i
    @start_date = current_user.trials.active.first.start_date
    @logged_interventions = InterventionUse.joins(:intervention_trial).where(["intervention_trials.user_id = ? AND intervention_uses.on_date = ?", current_user.id, @logging_date])
    @logged_dates = InterventionUse.find_by_sql(["select * from intervention_uses as iu join intervention_trials as it on iu.intervention_trial_id=it.id where on_date between ? and ? and it.user_id = ?", current_user.trials.active.first.start_date, current_user.trials.active.first.end_date, current_user.id]).map(&:on_date)
    @intervention_trials = current_user.intervention_trials.collect do |intervention_trial|
      {:id => intervention_trial.id, :intervention => intervention_trial.intervention, :taken => @logged_interventions.where(:intervention_trial_id => intervention_trial.id).map(&:taken)[0]}
    end
  end
end
