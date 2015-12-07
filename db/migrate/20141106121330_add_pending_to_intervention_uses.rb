class AddPendingToInterventionUses < ActiveRecord::Migration
  def change
    add_column :intervention_uses, :pending, :boolean, default: false
  end
end
