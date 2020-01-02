# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectProgramSummaryUpdater do
  let_it_be(:project) { create_default(:project) }
  let_it_be(:evaluation_program) { create_default(:evaluation_program) }
  subject { ProjectProgramSummaryUpdater.new(project.id, evaluation_program.id) }

  it 'calculates average_score correctly for follow-up programs' do
    pending 'FINISH ME 🙏'
    expect(false).to be(true)
  end
  it 'calculates average_score correctly for competition programs' do
    pending 'FINISH ME 🙏'
    expect(false).to be(true)
  end
  it 'sets the scores_summary correctly for follow-up programs' do
    pending 'FINISH ME 🙏'
    expect(false).to be(true)
  end
  it 'sets the scores_summary correctly for competition programs' do
    pending 'FINISH ME 🙏'
    expect(false).to be(true)
  end
end
