class CreateAppointments < ActiveRecord::Migration[6.1]
  def change
    create_table :appointments do |t|
      t.belongs_to :professional, null: false, foreign_key: { on_delete: :cascade}
      t.string :name
      t.string :surname
      t.string :phone
      t.string :notes
      t.datetime :date

      t.timestamps
    end
    add_index :appointments, :name, unique: true
  end
end
