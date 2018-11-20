class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    check_access
    @users = User.where(is_admin: nil)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    check_access
  end

  # GET /users/new
  def new
    check_access
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    check_access
  end

  # POST /users
  # POST /users.json
  def create
    check_access
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    check_access
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    check_access
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def check_access
    @role = session[:role]

    if @role != "admin"
      if @role == "realtor"
        @realtor = Realtor.find_by(:users_id => session[:user_id])
        redirect_to realtor_path(@realtor), notice: "You are not allowed to access that url"
      else
        @househunter = Househunter.find_by(:users_id => session[:user_id])
        redirect_to househunter_path(@househunter), notice: "You are not allowed to access that url"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email_id, :password, :is_admin, :is_realtor, :is_househunter)
    end
end
