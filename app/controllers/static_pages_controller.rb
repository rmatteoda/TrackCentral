class StaticPagesController < ApplicationController
  def home
  end

  def contact
  	@users = User.all
  end

  def help
  end
end
