# frozen_string_literal: true

#
# Base controller for the rest of the app
#
class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery
  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  after_action :verify_authorized, except: :index, unless: :devise_controller?

  private

  def user_not_authorized
    redirect_to root_path, alert: 'You are not allowed to access this resource'
  end
end
