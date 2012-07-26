class CreateActividads < ActiveRecord::Migration
  def change
    create_table :actividads do |t|
      t.string :tipo
      t.integer :vaca_id
      t.integer :valor
      t.datetime :registrada

      t.timestamps
    end
  end
end
