class AddReferencesToInterventionUses < ActiveRecord::Migration
  def change
    add_reference :intervention_uses, :user, index: true
    add_reference :intervention_uses, :intervention, index: true
    add_reference :intervention_uses, :trial, index: true
  end
end
