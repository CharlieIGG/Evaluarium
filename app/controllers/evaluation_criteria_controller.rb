# frozen_string_literal: true

class EvaluationCriteriaController < ApplicationController
  include ActAsConfig

  before_action :set_evaluation_criterium, only: %i[show edit update destroy]
  before_action :authorize_access

  def index
    @evaluation_criteria = EvaluationCriterium.order(:name).all.decorate
  end

  def new
    @evaluation_criterium = EvaluationCriterium.new.decorate
  end

  def edit; end

  def create
    @evaluation_criterium = EvaluationCriterium.new(evaluation_criterium_params)

    if @evaluation_criterium.save
      redirect_to evaluation_criteria_path, notice: 'Evaluation criterium was successfully created.'
    else
      render :new
    end
  end

  def update
    if @evaluation_criterium.update(evaluation_criterium_params)
      redirect_to evaluation_criteria_path, notice: 'Evaluation criterium was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @evaluation_criterium.destroy
    redirect_to evaluation_criteria_url, notice: 'Evaluation criterium was successfully destroyed.'
  end

  private

  def authorize_access
    return authorize @evaluation_criterium if @evaluation_criterium

    authorize EvaluationCriterium
  end

  def set_evaluation_criterium
    @evaluation_criterium = EvaluationCriterium.find(params[:id]).decorate
  end

  def evaluation_criterium_params
    params.require(:evaluation_criterium).permit(:name, :short_description,
                                                 :description)
  end
end
