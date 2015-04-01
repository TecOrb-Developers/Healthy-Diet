# reset entire database: DANGER for development only
# rm db/development.sqlite3; rm db/schema.rb; rake db:migrate; rake db:reset; rake db:seed

class InitialTables < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user
      t.string  :first_name
      t.string  :last_name
      t.string  :display_name
      t.string  :gender
      #t.date    :birthdate, null: false
      t.integer  :age
      t.string  :ethnicity
      t.timestamps
    end

    create_table :users_histories, :id => false do |t|
      t.references :user, null: false
      t.references :disease, null: false
      t.string     :history_type, null: false
      t.timestamps
    end

    create_table :diseases do |t|
      t.string :name, null: false
      # t.string :description  # TODO: to have more information about a disease to show users
      t.boolean :track_history, null: false, :default => false
      t.boolean :track_medicine, null: false, :default => false
    end

    create_table :variables do |t|
      t.string     :variable_type
      t.string     :name, null: false
      t.string     :unit
      t.integer    :precision, null: false, :default => 0
      t.string     :value_type, null: false
      t.string     :low
      t.string     :high
      t.string     :ideal
    end

    create_table :variables_diseases do |t|
      t.references :variable, null: false
      t.references :disease, null: false
    end

    create_table :users_variables do |t|
      t.references :user, null: false
      t.references :variable, null: false
      t.float      :value, null: false
      t.float      :value2
      t.timestamps
    end

    create_table :intervention_trials do |t|
      t.references :user
      t.references :intervention
      t.date :start_date
      t.date :end_date
    end

    create_table :intervention_uses do |t|
      t.references :intervention_trial, null: false
      t.date       :on_date, null: false 
      t.boolean    :taken
    end

    create_table :intervention_types do |t|  # should not be needed when interventions has principle_id
      t.string :name, null: false
    end

    create_table :interventions do |t|
      t.string :name, index: true, null: false
      #t.references :intervention_type, null: false #, index: true  # This isn't needed.  Basic if principle_id is not null.
      t.string :title
      t.string :abbrev
      t.text :benefit
      t.references :principle, index: true
      # t.string :tracks  DELETE because tracks to interventions is separate table.
      t.text :regimen
      t.text :alternate_options
      t.text :maintenance_dose
      t.text :safety_precautions
      t.string :image

      t.timestamps
    end

    create_table :interventions_diseases do |t|
      t.references :intervention, null: false
      t.references :disease, null: false
    end

    create_table :interventions_contraindications do |t|
      t.references :intervention, null: false
      t.references :disease, null: false
    end

    create_table :principles do |t|
      t.string :name, null: false
      t.text   :description
    end

    # Delete this table because interventions has principle_id
    #create_table :principles_interventions do |t|
    #  t.references :principles
    #  t.references :interventions
    #end

    create_table :tracks do |t|
      t.references :disease, null: false
      t.string :name, null: false
    end

    create_table :users_tracks do |t|
      t.references :user, null: false
      t.references :track, null: false
    end

    create_table :trials do |t|
      t.date :start_date, null: false
      t.date :end_date, null: false
    end

    create_table :users_trials do |t|
      t.references :user, null: false
      t.references :trial, null: false
    end

    create_table :pages do |t|
      t.string :name
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
