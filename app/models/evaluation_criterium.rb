# frozen_string_literal: true

# == Schema Information
#
# Table name: evaluation_criteria
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#


#
# This class is used to create the catalogue of different evaluation criteria
# that can later be added to an EvaluationProgram in order to evaluate Projects
#
class EvaluationCriterium < ApplicationRecord
  has_many :program_criteria
  has_many :evaluation_programs, -> { distinct }, through: :program_criteria
  has_many :project_evaluation_summaries, -> { distinct }, through: :evaluation_programs
end
