class Vaca < ActiveRecord::Base
  attr_accessible :caravana, :estado, :nodo_id, :raza, :rodeo
  
  has_one :nodo, :autosave => true
  has_many :actividades, dependent: :destroy, :class_name => "Actividad", :order => "registrada ASC"
  has_many :sucesos, dependent: :destroy, :class_name => "Suceso", :order => "momento DESC"
  has_many :celos, dependent: :destroy, :order => "comienzo DESC"#?? ASC
  
  validates :caravana, presence: true, uniqueness: true
end
