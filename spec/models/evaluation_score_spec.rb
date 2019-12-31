# frozen_string_literal: true

# == Schema Information
#
# Table name: evaluation_scores
#
#  id                            :bigint           not null, primary key
#  evaluation_criterium_id       :bigint           not null
#  project_evaluation_summary_id :bigint           not null
#  total                         :float
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#


require 'rails_helper'

RSpec.describe EvaluationScore, type: :model do
  subject { create(:evaluation_score) }
  it { should belong_to :project_evaluation_summary }
  it { should belong_to :evaluation_criterium }
  it { should validate_uniqueness_of(:evaluation_criterium_id).scoped_to(:project_evaluation_summary_id) }

  context 'lifecycle hooks' do
    let_it_be(:project_evaluation_summary, reload: true) { create(:project_evaluation_summary) }

    context 'on create' do
      it 'triggers a reevaluation of the Summarys average' do
        expect(project_evaluation_summary.average).to eq(0)

        create(:evaluation_score, total: 70, project_evaluation_summary: project_evaluation_summary)

        expect(project_evaluation_summary.reload.average).to eq(70)
      end

      it 'triggers an update of the Summarys scores' do
        expect(project_evaluation_summary.scores).to eq({})

        score = create(:evaluation_score, total: 70, project_evaluation_summary: project_evaluation_summary)

        expect(project_evaluation_summary.scores[score.name]).to eq(score.total)
      end
    end

    context 'on update' do
      let!(:score) { create(:evaluation_score, total: 70, project_evaluation_summary: project_evaluation_summary) }

      it 'triggers a reevaluation of the Summarys average' do
        expect(project_evaluation_summary.average).to eq(70)

        score.update(total: 80)

        expect(project_evaluation_summary.reload.average).to eq(80)
      end

      it 'triggers an update of the Summarys scores' do
        expect(project_evaluation_summary.scores[score.name]).to eq(70)

        score.update(total: 80)

        expect(project_evaluation_summary.scores[score.name]).to eq(80)
      end
    end

    context 'on destroy' do
      let!(:score) { create(:evaluation_score, total: 70, project_evaluation_summary: project_evaluation_summary) }

      it 'triggers a reevaluation of the Summarys average' do
        expect(project_evaluation_summary.average).to eq(70)

        score.destroy

        expect(project_evaluation_summary.reload.average).to eq(0)
      end

      it 'triggers an update of the Summarys scores' do
        expect(project_evaluation_summary.scores[score.name]).to eq(70)

        score.destroy

        expect(project_evaluation_summary.scores[score.name]).to eq(nil)
      end
    end
  end
end
