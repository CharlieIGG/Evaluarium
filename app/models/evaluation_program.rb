# frozen_string_literal: true

# == Schema Information
#
# Table name: evaluation_programs
#
#  id                          :bigint           not null, primary key
#  name                        :string           not null
#  start_at                    :datetime         not null
#  end_at                      :datetime
#  program_type                :integer          default("project_follow_up"), not null
#  score_calculation_method    :integer          not null
#  calculation_inclusion_count :integer
#  calculation_inclusion_unit  :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  criteria_scale_max          :float            not null
#  criteria_scale_min          :float            not null
#  criteria_step_size          :float            default(1.0), not null
#

#
# A wrapper for evaluations. A project (Startup) might be part of several
# EvaluationPrograms, some lasting hours, some lasting months, and each with different evaluators
#
class EvaluationProgram < ApplicationRecord
  MAXIMUM_VALID_SCORE = 100
  AVAILABLE_STEP_SIZES = [0.5, 1, 5, 10].freeze

  enum program_type: {
    project_follow_up: 0,
    competition: 1
  }

  has_many :project_evaluations
  has_many :program_criteria
  has_many :projects, through: :project_evaluations
  has_many :evaluation_criteria, through: :program_criteria

  validates :name, uniqueness: true, presence: true
  validates :criteria_scale_max, presence: true
  validates :criteria_scale_min, presence: true
  validates :criteria_step_size, presence: true
  validates_with EvaluationProgramValidator

  def total_current_percentage(options = { exclude_ids: [] })
    program_criteria.where.not(id: options[:exclude_ids]).sum(:weight)
  end
end
