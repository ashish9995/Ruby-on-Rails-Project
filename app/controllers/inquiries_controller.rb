class InquiriesController < ApplicationController
  before_action :set_inquiry, only: [:show, :edit, :update, :destroy]

  # GET /inquiries
  # GET /inquiries.json
  def index
    @inquiries = Inquiry.all
    @role = session[:role]
    if @role == "househunter"
      @househunter = Househunter.find_by(:users_id => session[:user_id])
      @inquiries = Inquiry.where(:househunters_id => @househunter.id)
    elsif @role == "realtor"
      @realtor = Realtor.find_by(:users_id => session[:user_id])
      @inquiries = Inquiry.joins("INNER JOIN houses h ON houses_id = h.id WHERE h.companies_id = #{@realtor.companies_id}")

    end
  end

  # GET /inquiries/1
  # GET /inquiries/1.json
  def show
  end

  # GET /inquiries/new
  def new
    @house = House.find_by(:id => params[:id])
    @househunter = Househunter.find_by(:users_id => session[:user_id])
    @inquiry = Inquiry.new
    @role = session[:role]
    check_access(@role)

  end

  # GET /inquiries/1/edit
  def edit
    @role = session[:role]
    if @role == "househunter"
      @househunter = Househunter.find_by(:users_id => session[:user_id])
    elsif @role == "realtor"
      @realtor = Realtor.find_by(:users_id => session[:user_id])
    end

  end

  # POST /inquiries
  # POST /inquiries.json
  def create

    @househunter = Househunter.find_by(:users_id => session[:user_id])
    @house = House.find_by(:id => inquiry_params[:house_id])
    @inquiry = Inquiry.new(:househunters_id => @househunter.id, :houses_id => inquiry_params[:house_id], :content => inquiry_params[:content], :subject => inquiry_params[:subject])

    respond_to do |format|
      if @inquiry.save
        format.html {redirect_to house_path(@house.id), notice: 'Inquiry was successfully created.'}
      else
        format.html {redirect_to request.referer, notice: 'Error'}
      end
    end
  end

  # PATCH/PUT /inquiries/1
  # PATCH/PUT /inquiries/1.json
  def update

    if session[:role] == "realtor"
      @househunter = Househunter.find_by(:id => @inquiry.househunters_id)
      @user = User.find_by(:id => @househunter.users_id)
    end

    respond_to do |format|
      if @inquiry.update(inquiry_params)
        if @inquiry.reply.present?
          UserMailer.welcome_email(@user,@inquiry).deliver_now
        end
        format.html {redirect_to inquiries_path, notice: 'Inquiry was successfully updated.'}
        format.json {render :show, status: :ok, location: @inquiry}
      else
        format.html {render :edit}
        format.json {render json: @inquiry.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /inquiries/1
  # DELETE /inquiries/1.json
  # DELETE /inquiries/1.json
  def destroy
    @inquiry.destroy
    respond_to do |format|
      format.html {redirect_to inquiries_url, notice: 'Inquiry was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  def check_access(role)
    if role == "realtor"
      @realtor = Realtor.find_by(:users_id => session[:user_id])
      redirect_to realtor_path(@realtor), notice: "You are not allowed to access that url"
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_inquiry
    @inquiry = Inquiry.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def inquiry_params
    params.require(:inquiry).permit(:subject, :content, :user_id, :house_id, :reply)
  end
end
