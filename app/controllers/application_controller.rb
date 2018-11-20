class ApplicationController < ActionController::Base

  def verify_logged_in
    # Ensure logged in if request is not either login path or register path
    if request.fullpath != login_path && request.fullpath != new_realtor_path && request.fullpath != new_househunter_path
      if request.fullpath.include? "oauth"
      else
        if session[:logged_in] != true
          redirect_to login_path, notice: "Please log in first"
        end
      end
    end
  end

  def set_previous_url
    @previous_url = request.referer
  end

  before_action :verify_logged_in, except: [:create]
  before_action :set_previous_url, except: [:create, :update]

end