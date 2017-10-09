class CreateGroupEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :group_events do |t|
      t.references :user, foreign_key: true
      t.datetime :start_date
      t.datetime :end_date
      t.integer :duration
      t.boolean :deleted, default: false
      t.integer :state, default: 0
      t.string :name
      t.text :description
      t.string :location

      t.timestamps
    end
  end
end
