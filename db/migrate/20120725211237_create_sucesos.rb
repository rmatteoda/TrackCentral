class CreateSucesos < ActiveRecord::Migration
  def change
    create_table :sucesos do |t|
      t.string :tipo
      t.integer :vaca_id
      t.date :momento

      t.timestamps
    end
  end
end
