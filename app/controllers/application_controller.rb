# frozen_string_literal: true

#
# Base controller for the rest of the app
#
class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  after_action :verify_authorized, except: :index, unless: :devise_controller?

  private

  def user_not_authorized
    redirect_to root_path, alert: 'You are not allowed to access this resource'
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[phone position name email id])
  end
end
