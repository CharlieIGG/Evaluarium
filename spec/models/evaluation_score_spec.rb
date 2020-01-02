# frozen_string_literal: true

# == Schema Information
#
# Table name: evaluation_scores
#
#  id                            :bigint           not null, primary key
#  program_criterium_id          :bigint           not null
#  project_evaluation_summary_id :bigint           not null
#  total                         :float
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#


require 'rails_helper'

RSpec.describe EvaluationScore, type: :model do
  subject { create(:evaluation_score) }
  it { should belong_to :project_evaluation_summary }
  it { should belong_to :program_criterium }
  it { should have_one :evaluation_program }

  it { should validate_uniqueness_of(:program_criterium_id).scoped_to(:project_evaluation_summary_id) }

  context 'validating numericality dynamically' do
    it 'is invalid if the total is outside of the EvaluationProgram\'s criteria_scale' do
      subject.evaluation_program.update(criteria_scale_min: 1, criteria_scale_max: 10)
      subject.total = 75
      expect(subject).not_to be_valid
      subject.total = 7.5
      expect(subject).to be_valid
      subject.total = 0
      expect(subject).not_to be_valid
      subject.total = 1
      expect(subject).to be_valid
    end
  end

  context 'lifecycle hooks' do
    let_it_be(:program) { create_default(:evaluation_program, criteria_scale_max: 100) }
    let_it_be(:project_evaluation_summary, reload: true) { create(:project_evaluation_summary, evaluation_program: program) }
    let_it_be(:weight) { 100 }
    let_it_be(:program_criterium) { create(:program_criterium, weight: weight, evaluation_program: program) }

    context 'on create' do
      it 'triggers a reevaluation of the Summarys total_score' do
        pending 'RE-DO TAKING INTO CONSIDERATION THE DIFFERENT POSSIBLE CALCULATION METHODS!'
        expect(project_evaluation_summary.total_score).to eq(0)

        create(:evaluation_score, total: 70, program_criterium: program_criterium, project_evaluation_summary: project_evaluation_summary)

        expect(project_evaluation_summary.reload.total_score).to eq(70)
      end

      it 'triggers an update of the Summarys scores' do
        pending 'RE-DO TAKING INTO CONSIDERATION THE DIFFERENT POSSIBLE CALCULATION METHODS!'
        expect(project_evaluation_summary.scores).to eq({})

        score = create(:evaluation_score, total: 70, program_criterium: program_criterium, project_evaluation_summary: project_evaluation_summary)

        expect(project_evaluation_summary.scores[score.name]).to eq(score.score_summary)
      end
    end

    context 'on update' do
      let!(:score) { create(:evaluation_score, total: 70, program_criterium: program_criterium, project_evaluation_summary: project_evaluation_summary) }

      it 'triggers a reevaluation of the Summarys total_score' do
        pending 'RE-DO TAKING INTO CONSIDERATION THE DIFFERENT POSSIBLE CALCULATION METHODS!'
        expect(project_evaluation_summary.total_score).to eq(70)

        score.update(total: 80)

        expect(project_evaluation_summary.reload.total_score).to eq(80)
      end

      it 'triggers an update of the Summarys scores' do
        pending 'RE-DO TAKING INTO CONSIDERATION THE DIFFERENT POSSIBLE CALCULATION METHODS!'
        expect(project_evaluation_summary.scores[score.name]).to eq(score.score_summary)

        score.update(total: 80)

        expect(project_evaluation_summary.scores[score.name]).to eq(score.score_summary)
      end
    end

    context 'on destroy' do
      pending 'RE-DO TAKING INTO CONSIDERATION THE DIFFERENT POSSIBLE CALCULATION METHODS!
      let!(:score) { create(:evaluation_score, total: 70, program_criterium: program_criterium, project_evaluation_summary: project_evaluation_summary) }

      it 'triggers a reevaluation of the Summarys total_score' do
        expect(project_evaluation_summary.total_score).to eq(70)

        score.destroy

        expect(project_evaluation_summary.reload.total_score).to eq(0)
      end

      it 'triggers an update of the Summarys scores' do
        expect(project_evaluation_summary.scores[score.name]).to eq(score.score_summary)

        score.destroy

        expect(project_evaluation_summary.scores[score.name]['weighed_points']).to eq(0)
      end
    end
  end
end
