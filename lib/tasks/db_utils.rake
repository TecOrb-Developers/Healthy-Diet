namespace :db_utils do
  desc "updates user_id, intervention_id and trial_id for intervention_uses"
  task intervention_uses_refs: :environment do
    InterventionUse.all.each do |iu|
      it = iu.intervention_trial
      i,u,t = nil
      i = it.try(:intervention)
      u = it.try(:user)
      t = u.trials.first unless u.nil?
      iu.update_attributes(user_id: u.id, intervention_id: i.id, trial_id: t.id) unless (u.nil? || i.nil? || t.nil?)
    end
  end

  desc "moves users in trial 1 to trial 5"
  task :move_trial_users, [:arg1, :arg2] => [:environment] do |t, args|
    moved_user_ids = UsersTrials.where(trial_id: args[:arg2]).map(&:user_id)
    UsersTrials.where(trial_id: args[:arg1]).where.not(user_id: moved_user_ids).each do |ut|
      UsersTrials.create(user_id: ut.user_id, trial_id: args[:arg2])
      puts "updating user id: " + ut.user_id.to_s + " from trial: " + args[:arg1] + " to " +  args[:arg2]
    end
  end
end
