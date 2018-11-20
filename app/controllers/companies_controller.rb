class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all
    @role = session[:role]
    if @role == "househunter"
      @househunter = Househunter.find_by(:users_id => session[:user_id])
    else
      @realtor = Realtor.find_by(:users_id => session[:user_id])
    end
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    @role = session[:role]
  end

  # GET /companies/new
  def new
    @company = Company.new
    session[:previous_url] ||= request.referer
    @previous_url = session[:previous_url]
    @role = session[:role]
    check_access(@role)

    if @role == "realtor"
      @realtor = Realtor.find_by(:users_id => session[:user_id])
    end
  end

  # GET /companies/1/edit
  def edit
    session[:previous_url] = request.referer
    @previous_url = session[:previous_url]
    @role = session[:role]
    check_access(@role)

    if @role == "realtor"
      @realtor = Realtor.find_by(:users_id => session[:user_id])
    end
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to session.delete(:previous_url), notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
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
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name, :website, :address, :employee_count, :foundation_year, :revenue, :synopsis)
    end
end
