class AddSettingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :settings, :boolean, default: true
  end
end
