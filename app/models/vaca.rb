class Vaca < ActiveRecord::Base
  attr_accessible :caravana, :estado, :nodo_id, :raza
  
  has_one :nodo, :autosave => true
  has_many :actividades, dependent: :destroy, :class_name => "Actividad"
  has_many :sucesos, dependent: :destroy, :class_name => "Suceso"
  has_many :celos, dependent: :destroy, :order => "comienzo DESC"#?? ASC
  
  validates :caravana, presence: true, uniqueness: true
end
