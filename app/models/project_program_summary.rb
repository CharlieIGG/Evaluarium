# frozen_string_literal: true

# == Schema Information
#
# Table name: project_evaluation_summaries
#
#  id                    :bigint           not null, primary key
#  average               :float
#  evaluation_program_id :bigint           not null
#  project_id            :bigint           not null
#  program_start         :date
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#


#
# This class depicts the track record for a Project in any given EvaluationProgram
#
class ProjectEvaluationSummary < ApplicationRecord
  belongs_to :evaluation_program
  belongs_to :project
end
