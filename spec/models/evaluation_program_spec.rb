# frozen_string_literal: true

# == Schema Information
#
# Table name: evaluation_programs
#
#  id         :bigint           not null, primary key
#  name       :string
#  start_at   :datetime
#  end_at     :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


require 'rails_helper'

RSpec.describe EvaluationProgram, type: :model do
  it { should have_many(:project_evaluation_summaries) }
  it { should have_many(:projects).through(:project_evaluation_summaries) }
  it { should have_many(:program_criteria) }
  it { should have_many(:evaluation_criteria).through(:program_criteria) }
  it { should validate_uniqueness_of(:name) }
end
