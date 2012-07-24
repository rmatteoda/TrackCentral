class Vaca < ActiveRecord::Base
  attr_accessible :caravana, :estado, :nodo_id, :raza
  
  has_one :nodo, :autosave => true

  validates :caravana, presence: true, uniqueness: true
end
