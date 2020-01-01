# frozen_string_literal: true

#
# Provides custom validaitons fot EvaluationScores
#
class EvaluationScoreValidator < ActiveModel::Validator
  def validate(record)
    @record = record
    validate_total_within_bounds
  end

  private

  def validate_total_within_bounds
    program = @record.evaluation_program
    return unless program

    total = @record.total
    min = program.criteria_scale_min
    max = program.criteria_scale_max
    return if total >= min && total <= max

    message = I18n.t('evaluation_score.total.out_of_bounds', min: min, max: max)
    @record.errors[:total] << message
  end
end
