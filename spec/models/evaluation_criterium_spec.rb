# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EvaluationCriterium, type: :model do
  it { should have_many :program_criteria }
  it { should have_many(:evaluation_programs).through(:program_criteria) }
  it { should have_many(:project_program_summaries).through(:evaluation_programs) }
end
