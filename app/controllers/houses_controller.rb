class HousesController < ApplicationController
  before_action :set_house, only: [:show, :edit, :update, :destroy]

  # GET /houses
  # GET /houses.json
  def index
    session[:previous_url] = request.referer
    @houses = House.all
    @role = session[:role]
    if @role == "househunter"
      @househunter = Househunter.find_by(:users_id => session[:user_id])
    elsif @role == "realtor"
      @realtor = Realtor.find_by(:users_id => session[:user_id])
    end
  end

  # GET /houses/1
  # GET /houses/1.json
  def show
    session[:previous_url] = request.referer
    @company_name = Company.find(House.find(params[:id]).companies_id).name
    @houseid = params[:id]
    @role = session[:role]

    if @role =="househunter"
      @househunter = Househunter.find_by(:users_id => session[:user_id])
      @interested_househunter = InterestedHousehunter.find_by(:house_id => params[:id], :househunter_id => @househunter.id)
    elsif @role == "realtor"
      @realtor = Realtor.find_by(:users_id => session[:user_id])
    end

  end

  def realtorhouses
    session[:previous_url] = request.referer
    rel = Realtor.find_by(users_id: session[:user_id])
    if rel.nil? == true || rel.companies_id == nil
      redirect_to session[:previous_url]
    else
      @houses = House.where(realtor_id: rel.id)
      @company = Company.find(rel.companies_id).name
    end
  end

  # GET /houses/new
  def new
    session[:previous_url] = request.referer
    @previous_url = request.referer
    @role = session[:role]
    check_access(@role)
    @realtor = Realtor.find_by(users_id: session[:user_id])

    @house = House.new
    if !session[:is_admin].nil? && session[:is_admin] == true
      @admin = true
      @companies = Company.all
    else
      realtor = Realtor.find_by(users_id: session[:user_id])
      if realtor != nil && realtor.companies_id != nil
        @company = Company.find(realtor.companies_id).name
      else
        redirect_to session[:previous_url], notice: "No company found!"
      end
    end
  end

  # GET /houses/1/edit
  def edit
    session[:previous_url] = request.referer
    @role = session[:role]
    check_access(@role)

    @house = House.find(params[:id])
    if !session[:is_admin].nil? && session[:is_admin] == true
      @admin = true
      @is_listing_creator = true
      @companies = Company.all
    else
      @realtor = Realtor.find_by(users_id: session[:user_id])
      if @realtor.companies_id != nil
        @company = Company.find(@realtor.companies_id).name
      end
    end

    if @role == "realtor"
      if @house.realtor_id != Realtor.find_by(users_id: session[:user_id]).id
        redirect_to houses_path, notice: "You cannot edit listing you have not posted"
      end
    end
    # todo: Delete extra tables in migrations
  end

  # POST /houses
  # POST /houses.json
  def create
    @house = House.new(house_params)
    realtor = Realtor.find_by(users_id: session[:user_id])

    if session[:role] != "admin"
      @house.realtor_id = realtor.id
      @house.companies_id = realtor.companies_id
    end
    respond_to do |format|
      if @house.save
        format.html {redirect_to houses_path, notice: 'House was successfully created.'}
        format.json {render :show, status: :created, location: @house}
      else
        format.html {redirect_to houses_path, notice: 'Error saving house'}
        format.json {render json: @house.errors, status: :unprocessable_entity}
      end
    end
  end

  def addimages
    if session[:role] == "realtor"
      realtor = Realtor.find_by(users_id: session[:user_id])
      @house = House.find(params[:id])
      if realtor.companies_id != @house.companies_id
        redirect_to realtor_path(realtor.id), notice: "house does not belong to your company" and return
      end
    elsif session[:role] == "househunter"
      redirect_to househunter_path(realtor.id), notice: "Only realtors can add images" and return
    end
  end

  # PATCH/PUT /houses/1
  # PATCH/PUT /houses/1.json
  def update
    respond_to do |format|
      if @house.update(house_params)
        format.html {redirect_to @house, notice: 'House was successfully updated.'}
        format.json {render :show, status: :ok, location: @house}
      else
        format.html {render :edit}
        format.json {render json: @house.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /houses/1
  # DELETE /houses/1.json
  def destroy
    if session[:role] != "admin"
      realtor = Realtor.find_by(users_id: session[:user_id])
      if realtor == nil || @house.realtor_id != realtor.id
        redirect_to houses_path, notice: "You cannot delete listing you have not posted"
      end
    end
    @house.destroy
    respond_to do |format|
      format.html {redirect_to houses_url, notice: 'House was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  def interested
    @househunter = Househunter.find_by(users_id: session[:user_id])
    @interested_househunter = InterestedHousehunter.find_by(:house_id => params[:id], :househunter_id => @househunter.id)

    respond_to do |format|
      if @interested_househunter
        format.html {redirect_to request.referer, notice: 'Already present in the interest list!'}
      else
        @interested_househunter = InterestedHousehunter.new(house_id: params[:id], househunter_id: @househunter.id)
        if @interested_househunter.save
          format.html {redirect_to request.referer, notice: 'Successful!'}
        else
          format.html {redirect_to request.referer, flash: {error: 'Error'}}
        end
      end
    end

  end

  def not_interested
    @househunter = Househunter.find_by(users_id: session[:user_id])
    @interested_househunter = InterestedHousehunter.find_by(:house_id => params[:id], :househunter_id => @househunter.id)

    respond_to do |format|
      if @interested_househunter.destroy
        format.html {redirect_to request.referer, notice: 'Successfully removed house from the interest list!'}
      else
        format.html {redirect_to request.referer, flash: {error: 'Error'}}
      end
    end
  end

  def check_access(role)
    if role == "househunter"
      @househunter = Househunter.find_by(:users_id => session[:user_id])
      redirect_to househunter_path(@househunter), notice: "You are not allowed to access that url"
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_house
    @house = House.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def house_params
    params.require(:house).permit(:realtor_id, :companies_id, :location, :area, :year_built, :style, :list_prize, :floor_count, :basement, :owner_name, images: [])
  end
end
