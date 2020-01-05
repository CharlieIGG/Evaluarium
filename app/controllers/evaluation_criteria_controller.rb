# frozen_string_literal: true

class EvaluationCriteriaController < ApplicationController
  include ActAsConfig

  before_action :set_evaluation_criterium, only: %i[show edit update destroy]

  # GET /evaluation_criteria
  def index
    @evaluation_criteria = EvaluationCriterium.order(:name).all.decorate
  end

  # GET /evaluation_criteria/1
  def show; end

  # GET /evaluation_criteria/new
  def new
    @evaluation_criterium = EvaluationCriterium.new
  end

  # GET /evaluation_criteria/1/edit
  def edit; end

  # POST /evaluation_criteria
  def create
    @evaluation_criterium = EvaluationCriterium.new(evaluation_criterium_params)

    if @evaluation_criterium.save
      redirect_to @evaluation_criterium, notice: 'Evaluation criterium was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /evaluation_criteria/1
  def update
    if @evaluation_criterium.update(evaluation_criterium_params)
      redirect_to @evaluation_criterium, notice: 'Evaluation criterium was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /evaluation_criteria/1
  def destroy
    @evaluation_criterium.destroy
    redirect_to evaluation_criteria_url, notice: 'Evaluation criterium was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_evaluation_criterium
    @evaluation_criterium = EvaluationCriterium.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def evaluation_criterium_params
    params.fetch(:evaluation_criterium, {})
  end
end
