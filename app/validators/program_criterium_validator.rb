# frozen_string_literal: true

class ProgramCriteriumValidator < ActiveModel::Validator
  MAXIMUM_VALID_PERCENTAGE = 100

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
    return unless total > MAXIMUM_VALID_PERCENTAGE

    @record.errors[:weight] << I18n.t('evaluation_criterium.weight.over_100')
  end
end
