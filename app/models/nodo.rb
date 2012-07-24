class Nodo < ActiveRecord::Base
  attr_accessible :bateria, :nodo_id, :vaca_id

  belongs_to :vaca

  validates :nodo_id, presence: true, uniqueness: true
end
