# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectProgramSummaryUpdater do
  let_it_be(:project) { create_default(:project) }
  let_it_be(:scale_max) { 5 }

  context 'for follow-up programs' do
    let_it_be(:evaluation_program) { create_default(:evaluation_program, program_type: :project_follow_up, criteria_scale_max: scale_max) }
    let_it_be(:summary) { create_default(:project_program_summary, project: project, evaluation_program: evaluation_program) }
    subject { ProjectProgramSummaryUpdater.new(project.id, evaluation_program.id) }
    let_it_be(:score_count) { 5 }
    let_it_be(:total_score) { 80.0 }
    let_it_be(:evaluation) { create(:project_evaluation, :with_homogeneous_scores, score_count: score_count, total_score: total_score, project: project, evaluation_program: evaluation_program) }

    it 'calculates average_score correctly' do
      subject.run

      expect(summary.reload.average_score).to be(total_score)
    end
    it 'sets the scores_summary[:criteria][:criteria_name] correctly' do
      subject.run
      evaluation_program.program_criteria.each do |criteria|
        criterium = summary.reload.scores_summary['criteria'][criteria.name]

        expect(criterium['total']).to eq(total_score * score_count / 100)
      end
    end
  end
  context 'for competition programs' do
    let_it_be(:evaluation_program) { create_default(:evaluation_program, program_type: :competition, criteria_scale_max: scale_max) }
    let_it_be(:summary) { create_default(:project_program_summary, project: project, evaluation_program: evaluation_program) }
    subject { ProjectProgramSummaryUpdater.new(project.id, evaluation_program.id) }
    let_it_be(:weight) { 25.0 }
    4.times do |n|
      let_it_be("evaluation_criterium_#{n}".to_sym) { create(:evaluation_criterium) }
      let_it_be("program_criterium_#{n}".to_sym) { create(:program_criterium, weight: weight, evaluation_criterium: send("evaluation_criterium_#{n}".to_sym), evaluation_program: evaluation_program) }
      let_it_be("evaluation_#{n}".to_sym) { create(:project_evaluation, project: project, evaluation_program: evaluation_program) }
    end
    4.times do |n|
      let_it_be("score_totals_#{n}".to_sym) { n + 1 }
      let_it_be("evaluation_scores_#{n}".to_sym) do
        create(:evaluation_score, total: send("score_totals_#{n}".to_sym), program_criterium: program_criterium_0, project_evaluation: send("evaluation_#{n}".to_sym))
        create(:evaluation_score, total: send("score_totals_#{n}".to_sym), program_criterium: program_criterium_1, project_evaluation: send("evaluation_#{n}".to_sym))
        create(:evaluation_score, total: send("score_totals_#{n}".to_sym), program_criterium: program_criterium_2, project_evaluation: send("evaluation_#{n}".to_sym))
        create(:evaluation_score, total: send("score_totals_#{n}".to_sym), program_criterium: program_criterium_3, project_evaluation: send("evaluation_#{n}".to_sym))
      end
    end

    before(:all) do
      evaluation_0.recalculate_total_score!
      evaluation_1.recalculate_total_score!
      evaluation_2.recalculate_total_score!
      evaluation_3.recalculate_total_score!
    end

    it 'calculates average_score correctly' do
      subject.run
      total_score = (score_totals_0 + score_totals_1 + score_totals_2 + score_totals_3) * weight / scale_max
      expect(summary.reload.average_score).to be(total_score)
    end

    it 'sets the scores_summary correctly' do
      subject.run
      scores = [score_totals_0, score_totals_1, score_totals_2, score_totals_3]
      4.times do |n|
        ev_criterium = send("evaluation_criterium_#{n}".to_sym)
        criterium = summary.reload.scores_summary['criteria'][ev_criterium.name]

        expect(criterium['total']).to eq(scores.sum.to_f / scores.length)
      end
    end
  end
end
