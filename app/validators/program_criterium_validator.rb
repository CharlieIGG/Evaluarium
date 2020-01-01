# frozen_string_literal: true

#
# Provides custom validations for ProgramCriteria
#
class ProgramCriteriumValidator < ActiveModel::Validator
  def validate(record)
    @record = record
    validate_percentage_consistency
  end

  private

  def validate_percentage_consistency
    program = @record.evaluation_program
    return unless program

    total_without_record = program.total_current_percentage(
      exclude_ids: [@record.id])
    total = total_without_record + @record.weight
    return unless total > EvaluationProgram::MAXIMUM_VALID_SCORE

    @record.errors[:weight] << I18n.t('program_criterium.weight.over_100')
  end
end
