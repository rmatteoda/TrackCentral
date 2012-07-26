class CreateAlarmas < ActiveRecord::Migration
  def change
    create_table :alarmas do |t|
      t.string :tipo
      t.integer :vaca_id
      t.integer :nodo_id
      t.datetime :registrada
      t.integer :horas_de_valides
      t.string :mensaje
      t.boolean :vista

      t.timestamps
    end
  end
end
