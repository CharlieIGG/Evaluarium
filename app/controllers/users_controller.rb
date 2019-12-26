# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update destroy]

  def index
    authorize User
    @deco_users = policy_scope(User.all).decorate
  end

  def new
    authorize User
    @user = User.new
  end

  def edit; end

  def update; end

  def destroy
    authorize @user
    return on_destroy_succeeded if @user.destroy

    redirect_to users_path, alert: @project.errors.full_messages
  end

  private

  def on_destroy_succeeded
    redirect_to users_path, notice: t('models.successfully_deleted')
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
