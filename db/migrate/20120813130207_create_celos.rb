class CreateCelos < ActiveRecord::Migration
  def change
    create_table :celos do |t|
      t.integer :vaca_id
      t.datetime :comienzo
      t.string :probabilidad
      t.string :causa

      t.timestamps
    end
  end
end
