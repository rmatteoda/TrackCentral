class Celo < ActiveRecord::Base
  attr_accessible :causa, :comienzo, :probabilidad, :vaca_id

  belongs_to :vaca
end
