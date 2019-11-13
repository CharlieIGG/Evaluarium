# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectProgramSummary, type: :model do
  subject { build_stubbed(:project_program_summary) }

  it { should belong_to(:project) }
  it { should belong_to(:evaluation_program) }
end
