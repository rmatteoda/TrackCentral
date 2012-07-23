class CreateNodos < ActiveRecord::Migration
  def change
    create_table :nodos do |t|
      t.integer :bateria
      t.integer :vaca_id
      t.string :nodo_id

      t.timestamps
    end
  end
end
