class AddCaravanaToCelo < ActiveRecord::Migration
  def change
    add_column :celos, :caravana, :integer
  end
end
