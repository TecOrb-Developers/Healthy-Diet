class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
 # protect_from_forgery with: :exception

  def stored_location_for(resource)
    nil
  end

  def after_sign_in_path_for(resource)
    dashboard_index_path
  end

  def authenticate_admin!
    redirect_to root_path unless (current_user && current_user.admin?)
  end
end
