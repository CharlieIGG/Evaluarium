# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProgramCriterium, type: :model do
  it { should belong_to :evaluation_criterium }
  it { should belong_to :evaluation_program }
  it { should have_many(:project_program_summaries).through(:evaluation_program) }
end
