class Suceso < ActiveRecord::Base
  attr_accessible :momento, :tipo, :vaca_id

  belongs_to :vaca
  
end
