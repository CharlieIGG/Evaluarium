# frozen_string_literal: true

# == Schema Information
#
# Table name: program_criteria
#
#  id                      :bigint           not null, primary key
#  evaluation_program_id   :bigint           not null
#  evaluation_criterium_id :bigint           not null
#  position                :integer
#  weight                  :float
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#


#
# This is an "instance" of an EvaluationCriteria scoped to a specific
# evaluation program. Each "instance" carries it's own position (order)
# and it's own weight, which will ultimately be used to calculate a total % in
# each Project's ProjectEvaluationSummary
#
class ProgramCriterium < ApplicationRecord
  belongs_to :evaluation_program
  belongs_to :evaluation_criterium
  has_many :evaluation_scores

  validates :evaluation_criterium_id, uniqueness: { scope: :evaluation_program_id }
end
