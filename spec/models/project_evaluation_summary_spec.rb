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


require 'rails_helper'

RSpec.describe ProjectEvaluationSummary, type: :model do
  subject { build_stubbed(:project_evaluation_summary) }

  it { should belong_to(:project) }
  it { should belong_to(:evaluation_program) }
  it { should have_many(:evaluation_scores) }
end
