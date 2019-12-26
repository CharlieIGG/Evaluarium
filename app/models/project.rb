# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id         :bigint           not null, primary key
#  name       :string
#  founded_at :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


#
# Projects to evaluate, these might be Startups or something similar
#
class Project < ApplicationRecord
  has_many :project_program_summaries
  has_many :evaluation_programs, through: :project_program_summaries
end
