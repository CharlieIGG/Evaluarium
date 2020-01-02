# frozen_string_literal: true

# == Schema Information
#
# Table name: evaluation_programs
#
#  id                 :bigint           not null, primary key
#  name               :string
#  start_at           :datetime
#  end_at             :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  criteria_scale_max :float            not null
#  criteria_scale_min :float            not null
#  criteria_step_size :float            default(1.0), not null
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

  enum score_calculation_method: {
    take_latest: 0,
    take_average: 1
  }

  enum calculation_inclusion_unit: {
    minutes: 0,
    hours: 1,
    days: 2,
    weeks: 3,
    months: 4,
    score_entries: 5
  }

  has_many :project_evaluation_summaries
  has_many :program_criteria
  has_many :projects, through: :project_evaluation_summaries
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
