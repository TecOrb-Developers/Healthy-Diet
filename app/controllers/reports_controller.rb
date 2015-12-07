class ReportsController < ApplicationController
  before_action :authenticate_admin!

  def index

  end

  def user_report
    @users_trials = Trial.order(:id).collect {|t| [t, UsersTrials.find_all_by_trial_id(t.id).map(&:user)]}
  end

  def user_details
    @user = User.find(params[:id])
    @profile = Profile.find_by_user_id(params[:id])
    @histories = UsersHistories.find_all_by_user_id(params[:id], order: 'created_at')
    @variables = UsersVariables.find_all_by_user_id(params[:id], order: 'created_at')
    @intervention_uses = InterventionUse.find_all_by_user_id(params[:id], order: 'on_date')
  end

  private

  def authenticate_admin!
    redirect_to root_path unless (current_user && current_user.admin?)
  end
end
