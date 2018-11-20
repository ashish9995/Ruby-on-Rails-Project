class HousehuntersController < ApplicationController
  before_action :set_househunter, only: [:show, :edit, :update, :destroy]

  # GET /househunters
  # GET /househunters.json
  def index
    @role = session[:role]
    @househunters = Househunter.all
    if session[:role] != "admin"
      redirect_to login_path, notice: "You are not allowed to access that url"
    end
  end

  # GET /househunters/1
  # GET /househunters/1.json
  def show

    @user = User.find(@househunter.users_id)
    #UserMailer.welcome_email.deliver_now
    @role = session[:role]
    check_access(@role)
    if @role == "househunter"
      @househunter = Househunter.find_by(:users_id => session[:user_id])
    end
    user = User.find(session[:user_id])
    if user.is_realtor == true
      @switchable = true
    end
  end

  # GET /househunters/new
  def new
    @role = session[:role]
    check_access(@role)
    @househunter = Househunter.new
  end

  # GET /househunters/1/edit
  def edit
    @role = session[:role]
    check_access(@role)
    @househunter = Househunter.find(params[:id])
  end

  # POST /househunters
  # POST /househunters.json
  def create
    existing_user = User.find_by(email_id: params[:user][:email_id])
    if existing_user != nil
      if existing_user.is_househunter == true
        redirect_to logout_path, notice: "You are already registered as a house hunter"
      else
        existing_user.is_househunter = true
        existing_user.password = params[:user][:password]
        if existing_user.save
          add_hh = Househunter.new(househunter_params)
          add_hh.users_id = existing_user.id
          if add_hh.save
            redirect_to login_path, notice: 'House hunter was successfully created'
          else
            redirect_to login_path, notice: 'Error saving househunter'
          end
        else
          redirect_to login_path, notice: 'Error saving user.'
        end
      end
    else
      @househunter = Househunter.new(househunter_params)
      @user = User.new(user_params)
      @user.is_househunter = true
      respond_to do |format|
        if @user.save
          @househunter.users_id = @user.id
          if @househunter.save
            format.html {redirect_to login_path, notice: 'House hunter was successfully created.'}
            format.json {render :show, status: :created, location: @househunter}
          else
            format.html {render :new}
            format.json {render json: @realtor.errors, status: :unprocessable_entity}
          end
        else
          format.html {render :new}
          format.json {render json: @user.errors, status: :unprocessable_entity}
        end
      end
    end
  end

  # PATCH/PUT /househunters/1
  # PATCH/PUT /househunters/1.json
  def update
    respond_to do |format|
      if @househunter.update(househunter_params)
        if params[:user][:password] != nil && params[:user][:password] != ""
          if User.find(session[:user_id]).update(password: params[:user][:password])
            reset_session
            redirect_to login_path, notice: 'Password successfully changed' and return
          else
            redirect_to @househunter, notice: 'Error changing password'
          end
        end
        format.html {redirect_to @househunter, notice: 'Househunter was successfully updated.'}
        format.json {render :show, status: :ok, location: @househunter}
      else
        format.html {render :edit}
        format.json {render json: @househunter.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /househunters/1
  # DELETE /househunters/1.json
  def destroy
    @user = User.find_by(:id => @househunter.users_id)
    @househunter.destroy()
    if @user.is_admin != true && @user.is_realtor != true
      @user.destroy
    else
      @user.is_househunter = 0
      @user.save
    end
    respond_to do |format|
      format.html {redirect_to househunters_url, notice: 'Househunter was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  def input
    @previous_url = request.referrer
    @role = session[:role]
    if @role == "househunter"
      @househunter = Househunter.find_by(:users_id => session[:user_id])
    else
      @realtor = Realtor.find_by(:users_id => session[:user_id])
    end
  end

  def search
    @role = session[:role]
    if @role == "househunter"
      @househunter = Househunter.find_by(:users_id => session[:user_id])
    else
      @realtor = Realtor.find_by(:users_id => session[:user_id])
    end


    str = ""
    if params[:location] != nil && params[:location] != ""
      if str.empty?
        str = str + " location = '#{params[:location]}'"
      else
        str = str + "AND location = '#{params[:location]}' "
      end
    end
    if (params[:year_built1]== nil || params[:year_built1]== "" )&& ( params[:year_built2]==nil || params[:year_built2]=="")
      str=str+""
    else
      if params[:year_built1] == nil || params[:year_built1] == ""
        miny=0
      else
        miny=params[:year_built1]
      end
      if params[:year_built2] == nil || params[:year_built2] == ""
        maxy=99999
      else
        maxy=params[:year_built2]
      end
      if str.empty?
        str = str + " year_built > #{miny} AND year_built < #{maxy} "
      else
        str = str + " AND year_built > #{miny} AND year_built < #{maxy} "
      end
    end

    if params[:style] != nil && params[:style] != ""
      if str.empty?
        str = str + " style = '#{params[:style]}' "
      else
        str = str + " AND style = '#{params[:style]}' "
      end
    end
    if (params[:list_prize1]==nil || params[:list_prize1]=="" )&&  (params[:list_prize2]==nil || params[:list_prize2]=="")
      str=str+""
    else
      if params[:list_prize1] == nil || params[:list_prize1] == ""
        minl=0
      else
        minl=params[:list_prize1]
      end
      if params[:list_prize2] == nil || params[:list_prize2] == ""
        maxl=99999
      else
        maxl=params[:list_prize2]
      end
      if str.empty?
        str = str + " list_prize > #{minl} AND list_prize < #{maxl} "
      else
        str = str + " AND list_prize => #{minl} AND list_prize < #{maxl} "
      end
    end

    if (params[:floor_count1]==nil || params[:floor_count1]=="") &&  (params[:floor_count2]==nil || params[:floor_count2]=="")
      str=str+""
    else
      if params[:floor_count1] == nil || params[:floor_count1] == ""
        minf=0
      else
        minf=params[:floor_count1]
      end
      if params[:floor_count2] == nil || params[:floor_count2] == ""
        maxf=99999
      else
        maxf=params[:area2]
      end
      if str.empty?
        str = str + " floor_count > #{minf} AND floor_count < #{maxf} "
      else
        str = str + " AND floor_count > #{minf} AND floor_count < #{maxf} "
      end
    end
    if params[:basement] != nil && params[:basement] != ""
      if str.empty?
        str = str + " basement=#{params[:basement]} "
      else
        str = str + " AND basement=#{params[:basement]} "
      end
    end
    if params[:owner_name] != nil && params[:owner_name] != ""
      if str.empty?
        str = str + " owner_name='#{params[:owner_name]}' "
      else
        str = str + " AND owner_name='#{params[:owner_name]}' "
      end
    end

      @houses =House.where(str)
  end

  def check_access(role)
    if role == "realtor"
      @realtor = Realtor.find_by(:users_id => session[:user_id])
      redirect_to realtor_path(@realtor), notice: "You are not allowed to access that url"
    end
  end

  def switch
    session[:role] = 'realtor'
    redirect_to login_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_househunter
    @househunter = Househunter.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def househunter_params
    params.require(:househunter).permit(:first_name, :last_name, :phone, :contact_method, :users_id)
  end

  def user_params
    params.require(:user).permit(:email_id, :password, :is_admin, :is_realtor, :is_househunter)
  end
end
