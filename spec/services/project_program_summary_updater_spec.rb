# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectProgramSummaryUpdater do
  let_it_be(:project) { create_default(:project) }
  let_it_be(:evaluation_program) { create_default(:evaluation_program) }
  let_it_be(:summary) { create_default(:project_program_summary, project: project, evaluation_program: evaluation_program) }
  subject { ProjectProgramSummaryUpdater.new(project.id, evaluation_program.id) }

  context 'for follow-up programs' do
    let(:score_count) { 5 }
    let(:total_score) { 80 }
    let_it_be(:evaluation) { create(:project_evaluation, :with_homogeneous_scores, score_count: score_count, total_score: total_score, project: project, evaluation_program: evaluation_program) }

    it 'calculates average_score correctly' do
      subject.run
      expect(summary.average_score).to be(total_score)
    end
    it 'sets the scores_summary[:criteria][:criteria_name] correctly' do
      subject.run
      evaluation_program.program_criteria.each do |criteria|
        expect(summary.scores_summary[:criteria][criteria.name.to_sym]).to eq(total_score/score_count)
      end
    end
  end
  context 'for competition programs' do
    it 'calculates average_score correctly' do
      pending 'FINISH ME 🙏'
      expect(false).to be(true)
    end
    it 'sets the scores_summary correctly' do
      pending 'FINISH ME 🙏'
      expect(false).to be(true)
    end
  end
end
