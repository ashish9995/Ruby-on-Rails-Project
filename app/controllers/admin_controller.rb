class AdminController < ApplicationController
  def show
    @admin = User.find_by(is_admin: true)
  end

  def edit
    @admin = User.find_by(is_admin: true)
  end

  def update
    respond_to do |format|
      if @admin.update(params)
        format.html { redirect_to admin_path, notice: 'Admin was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
end
