class DashboardController < ApplicationController
  before_action :set_display_name, only: :index
  before_action :registration_step, only: :index

  def index
    render 'index'
  end

  def show
    render 'start_trial'
  end

  def start_trial
    render 'start_trial'
  end

  def new_user
    render 'new_user'
  end

  def daily_update
    render 'daily_update'
  end

  private

  # where/how is this called from?  dashboard#index.html?
  def registration_step
    @registration_step = nil
    if !current_user
      redirect_to home_index_path
    else
      @completed_trials = current_user.trials.past
      if (current_user.intervention_trials.count != 0)
        @intervention_trials = current_user.intervention_trials
        if !((current_user.trials.active.count != 0) || (current_user.trials.future.count != 0))
          @registration_step = 'trial'
          @trials = Trial.future
          if @trials.count < 5
            today = Time.zone.now.to_date
            6.times do |i|
              next_id = Trial.last.present? ?  (Trial.last.id + 1) : 0
              start_date = Trial.last.present? ?  (Trial.last.start_date.beginning_of_week() + 7.days) : Time.now
              end_date = start_date + 28.days
              Trial.create(id: next_id, start_date: start_date, end_date: end_date)
            end
            @trials = Trial.future
          end
        elsif (current_user.trials.active.count == 0) && (current_user.trials.future != 0)
          @registration_step = 'waiting'
          @days_to_next_trial = (current_user.trials.future.first.start_date - Time.zone.now.to_date).to_i
          @intervention_trials = current_user.intervention_trials.map(&:intervention)
        elsif (current_user.trials.active.count != 0)
          @registration_step = 'active'
          @day_count = (Time.zone.now.to_date - current_user.trials.active.first.start_date).to_i + 1
          @current_count = @day_count
          @start_date = current_user.trials.active.first.start_date
          @logged_today = (InterventionUse.joins(:intervention_trial).where(["intervention_trials.user_id = ? AND intervention_uses.on_date = ?", current_user.id, Time.zone.now.to_date.to_s]).count != 0)
          @logged_dates = InterventionUse.find_by_sql(["select * from intervention_uses as iu join intervention_trials as it on iu.intervention_trial_id=it.id where on_date between ? and ? and it.user_id = ?", current_user.trials.active.first.start_date, current_user.trials.active.first.end_date, current_user.id]).map(&:on_date)
        end
      else
        if current_user.profile.nil?
          @registration_step = 'new'
          redirect_to profiles_path
          return
        elsif current_user.tracks.count == 0
          @registration_step = 'track'
        elsif current_user.intervention_trials.count == 0
          @registration_step = 'supplement'
        end
      end
      render 'index'
    end
  end

  def set_display_name
    if current_user.profile && current_user.profile.display_name.present?
      @display_name = current_user.profile.display_name
    else
      @display_name = nil
    end
  end

end
