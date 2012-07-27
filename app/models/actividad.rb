class Actividad < ActiveRecord::Base
  attr_accessible :registrada, :tipo, :vaca_id, :valor

  belongs_to :vaca
  
  validates :tipo, presence: true
  validates :registrada, presence: true
  validates :vaca_id, presence: true
 
  #default_scope order: 'actividad.registrada ASC'
end
