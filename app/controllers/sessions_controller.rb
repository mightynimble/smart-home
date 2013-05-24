class SessionsController < ApplicationController
  def new
  end

  def create
    users = User.find_all_by_uid(params[:user][:uid])
    if !users.blank?
      user = users.first
      if user.authenticate(params[:user][:password])
        session[:user] = user.attributes
        render 'dashboards/index'
      else
        redirect_to root_url
      end
    else
      redirect_to root_url
    end
  end

  def destroy
    session[:user] = nil
    redirect_to root_url
  end
end
