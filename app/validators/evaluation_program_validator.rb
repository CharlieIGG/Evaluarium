# frozen_string_literal: true

#
# Custom validations for EvaluationPrograms
#
class EvaluationProgramValidator < ActiveModel::Validator
  def validate(record)
    @record = record
    validate_min_max_consistency
    validate_step_size_consistency
    validate_step_size_compatibility
  end

  private

  def validate_min_max_consistency
    min = @record.criteria_scale_min
    max = @record.criteria_scale_max
    return unless min.present? && max.present? && min >= max

    message = I18n.t('evaluation_program.criteria_scale_max.inconsistent', min: min)
    @record.errors[:criteria_scale_min] << message
  end

  def validate_step_size_consistency
    scale_max = @record.criteria_scale_max
    step_size = @record.criteria_step_size
    return unless scale_max && step_size && scale_max / step_size < 2

    @record.errors[:criteria_step_size] <<  I18n.t('evaluation_program.criteria_step_size.inconsistent')
  end

  def validate_step_size_compatibility
    scale_max = @record.criteria_scale_max
    step_size = @record.criteria_step_size
    return unless scale_max && step_size && scale_max % step_size != 0

    @record.errors[:criteria_step_size] <<  I18n.t('evaluation_program.criteria_step_size.incompatible')
  end
end
