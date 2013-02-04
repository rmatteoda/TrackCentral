class AddRodeoToVaca < ActiveRecord::Migration
  def change
    add_column :vacas, :rodeo, :integer
  end
end
