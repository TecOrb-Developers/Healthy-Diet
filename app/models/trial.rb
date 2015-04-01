class Trial < ApplicationModel

  has_many :users_trials, :class_name => UsersTrials
  has_many :users, :through => :users_trials
  

  def self.active
    today = Time.zone.now.to_date
    where "start_date <= '#{today.to_s}' AND end_date >= '#{today.to_s}'"
  end

  def self.past
    today = Time.zone.now.to_date
    where "end_date < '#{today.to_s}'"
  end

  def self.future
    today = Time.zone.now.to_date
    where "start_date > '#{today.to_s}'"
  end
end
