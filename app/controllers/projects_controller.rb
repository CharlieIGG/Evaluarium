class ProjectsController < ApplicationController
  
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authorize_access

  def index
    @projects = policy_scope(Project).decorate
  end

  def show; end

  def new
    @project = Project.new.decorate
  end

  def edit; end

  def create
    @project = Project.new(project_params).decorate
    return on_save_success if @project.save

    render :new
  end

  def update
    return on_save_success if @project.update(project_params)

    render :edit
  end

  def destroy
    return on_destroy_success if @project.destroy

    redirect_to(projects_url, alert: 'Project could not be destroyed.')
  end

  private

  def on_save_success
    redirect_to projects_url, notice: 'Project was successfully saved.'
  end

  def on_destroy_success
    redirect_to projects_url, notice: 'Project was successfully destroyed.'
  end

  def set_project
    @project = Project.find(params[:id]).decorate
  end

  def authorize_access
    return authorize @project if @project

    authorize EvaluationCriterium
  end

  def project_params
    params.require(:project).permit(:name, :founded_at)
  end
end
