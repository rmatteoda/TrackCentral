class CreateVacas < ActiveRecord::Migration
  def change
    create_table :vacas do |t|
      t.integer :caravana
      t.string :raza
      t.string :estado
      t.string :nodo_id

      t.timestamps
    end
  end
end
