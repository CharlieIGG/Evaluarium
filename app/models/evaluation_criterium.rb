# frozen_string_literal: true

# == Schema Information
#
# Table name: evaluation_criteria
#
#  id                :bigint           not null, primary key
#  name              :string
#  short_description :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

#
# This class is used to create the catalogue of different evaluation criteria
# that can later be added to an EvaluationProgram in order to evaluate Projects
#
class EvaluationCriterium < ApplicationRecord
  has_rich_text :description
  has_many :program_criteria
  has_many :evaluation_scores
  has_many :evaluation_programs, -> { distinct }, through: :program_criteria
  has_many :project_evaluations, -> { distinct }, through: :evaluation_programs

  validates :name, uniqueness: true, presence: true
  validates :short_description, presence: true
end
