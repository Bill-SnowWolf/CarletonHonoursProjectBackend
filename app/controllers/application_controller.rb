class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Require Authorization
  before_action :custom_authentication!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Custom Parameters during devise authentication
  def configure_permitted_parameters
    # devise_parameter_sanitizer.for(:sign_up).push(:variable_name)
  end

  def custom_authentication!
    open_routes = ['admin/','active_admin/devise/sessions', 'pusher']
    authenticate_user! unless open_routes.any? { |path| 
      "/#{params[:controller]}/".include? path
    }
  end
end
