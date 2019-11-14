# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EvaluationProgram, type: :model do
  it { should have_many(:project_program_summaries) }
  it { should have_many(:projects).through(:project_program_summaries) }
  it { should have_many(:program_criteria) }
  it { should have_many(:evaluation_criteria).through(:program_criteria) }
end
