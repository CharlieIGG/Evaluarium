# frozen_string_literal: true

# == Schema Information
#
# Table name: project_program_summaries
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

RSpec.describe ProjectProgramSummary, type: :model do
  subject { build_stubbed(:project_program_summary) }

  it { should belong_to(:project) }
  it { should belong_to(:evaluation_program) }
  it { should have_many(:program_criteria).through(:evaluation_program) }
end
