class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :index, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  
  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Configuracion actualizada"
      #sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      #sign_in @user
      flash[:success] = "Usuario Creado"
      redirect_to users_path
    else
      render 'new'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Usuario Eliminado"
    redirect_to users_path
  end

   private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Ingresar al sistema"
      end
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end
