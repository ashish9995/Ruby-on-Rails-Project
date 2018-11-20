class RealtorsController < ApplicationController
  before_action :set_realtor, only: [:show, :edit, :update, :destroy]

  # GET /realtors
  # GET /realtors.json
  def index
    @role = session[:role]
    check_access(@role)
    if session[:role] != "admin"
      redirect_to login_path, notice: "You cannot access the page"
    end
    @realtors = Realtor.all
  end

  # GET /realtors/1
  # GET /realtors/1.json
  def show
    @role = session[:role]
    check_access(@role)
    # Show company name if realtor belongs to company
    @realtor = Realtor.find(params[:id])
    if @realtor.companies_id != nil
      @company = Company.find(@realtor.companies_id)
    end
    if session[:role] == 'admin'
      redirect_to login_path
    else
      user = User.find(session[:user_id])
      if user.is_househunter == true
        @switchable = true
      end
    end
  end

  # GET /realtors/new
  def new
    @role = session[:role]
    check_access(@role)
    @realtor = Realtor.new
  end

  # GET /realtors/1/edit
  def edit
    @role = session[:role]
    check_access(@role)
    @realtor = Realtor.find(params[:id])
    @companies = Company.all # To populate dropdown
    if @realtor.companies_id != nil
      @company = @realtor.companies_id
    end
  end

  # POST /realtors
  # POST /realtors.json
  def create
    existing_user = User.find_by(email_id: params[:user][:email_id])
    if existing_user != nil
      if existing_user.is_realtor == true
        redirect_to login_path, notice: 'You are already registered as an Realtor'
      else
        existing_user.is_realtor = true
        existing_user.password = params[:user][:password]
        if existing_user.save
          add_realtor = Realtor.new(realtor_params)
          add_realtor.users_id = existing_user.id
          if add_realtor.save
            redirect_to login_path, notice: 'Realtor was successfully created.'
          else
            redirect_to login_path, notice: 'Error saving realtor.'
          end
        else
          redirect_to login_path, notice: 'Error saving user.'
        end
      end
    else
      @realtor = Realtor.new(realtor_params)
      @user = User.new(user_params)
      @user.is_realtor = true
      respond_to do |format|
        if @user.save
          @realtor.users_id = @user.id
          if @realtor.save
            format.html {redirect_to login_path, notice: 'Realtor was successfully created.'}
            format.json {render :show, status: :created, location: @realtor}
          else
            format.html {redirect_to login_path, notice: 'Error creating realtor'}
            format.json {render json: @realtor.errors, status: :unprocessable_entity}
          end
        else
          format.html {redirect_to login_path, notice: 'Error creating user. Please check input.'}
          format.json {render json: @user.errors, status: :unprocessable_entity}
        end
      end
    end
  end

  def potential
    rel = Realtor.find_by(users_id: session[:user_id])
    @potential = InterestedHousehunter.select('h.id','hh.first_name','hh.last_name').joins("inner join houses h on h.id = house_id inner join househunters hh on hh.id = househunter_id").where("h.companies_id=#{rel.companies_id}")

    #session[:previous_url] = request.referer
    # rel = Realtor.find_by(users_id: session[:user_id])
    # puts rel.id
    # @com = Company.find(rel.companies_id)
    # @house = House.where(:companies_id => @com.id)
    # #hh = Hash.new
    # fh = Hash.new
    # @fu = Hash.new
    # i = 0
    # j = 0
    # puts @house
    # @house.each do |h|
    #
    #   hh = InterestedHousehunter.where(:house_id => h[:id])
    #   unless hh.empty?
    #     @fu[i] = Househunter.where(:id => hh[0][:househunter_id])
    #     i = i + 1
    #   end
    #   #fh[i]={h.id=>h,hh[h.id][:househunter_id]=>fu[hh[h.id][:househunter_id]]}
    #   #i=i+1
    # end
    # #@househunters=Househunter.find_by()
  end

  # PATCH/PUT /realtors/1
  # PATCH/PUT /realtors/1.json
  def update
    prev_company = @realtor.companies_id
    respond_to do |format|
      if @realtor.update(realtor_params)
        if @realtor.companies_id != prev_company
          House.where(companies_id: prev_company).destroy_all
        end
        if params[:user][:password] != nil && params[:user][:password] != ""
          if User.find(session[:user_id]).update(password: params[:user][:password])
            reset_session
            redirect_to login_path, notice: 'Password successfully changed' and return
          else
            redirect_to @realtor, notice: 'Error changing password'
          end
        end
        format.html {redirect_to @realtor, notice: 'Realtor was successfully updated.'}
        format.json {render :show, status: :ok, location: @realtor}
      else
        format.html {render :edit}
        format.json {render json: @realtor.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /realtors/1consist
  # DELETE /realtors/1.json
  def destroy
    @user = User.find_by(:id => @realtor.users_id)
    if @user.is_admin != true && @user.is_househunter != true
      @user.destroy
    else
      @user.is_realtor = 0
      @user.save
    end
    @realtor.destroy

    respond_to do |format|
      format.html {redirect_to realtors_url, notice: 'Realtor was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  def check_access(role)
    if role == "househunter"
      @househunter = Househunter.find_by(:users_id => session[:user_id])
      redirect_to househunter_path(@househunter), notice: "You are not allowed to access that url"
    end
  end

  def switch
    session[:role] = 'househunter'
    redirect_to login_path
  end

  def gcreate
    @user = User.find_or_create_from_auth_hash(request.env["omniauth.auth"])
    session[:role] = 'realtor'
    session[:user_id] = @user.id
    session[:is_realtor] = true
    session[:logged_in] = true
    redirect_to login_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_realtor
    @realtor = Realtor.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def realtor_params
    params.require(:realtor).permit(:first_name, :last_name, :companies_id, :phone_number, :user_id)
  end

  #Allows saving of user from within realtors controller.
  def user_params
    params.require(:user).permit(:email_id, :password, :is_admin, :is_realtor, :is_househunter)
  end

end
