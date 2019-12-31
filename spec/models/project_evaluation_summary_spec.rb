# frozen_string_literal: true

# == Schema Information
#
# Table name: project_evaluation_summaries
#
#  id                    :bigint           not null, primary key
#  average               :float
#  evaluation_program_id :bigint           not null
#  project_id            :bigint           not null
#  program_start         :date
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  timestamp             :datetime
#  scores                :jsonb
#


require 'rails_helper'

RSpec.describe ProjectEvaluationSummary, type: :model do
  subject { build_stubbed(:project_evaluation_summary) }

  it { should belong_to(:project) }
  it { should belong_to(:evaluation_program) }
  it { should have_many(:evaluation_scores) }
  it do
    should(validate_numericality_of(:average)
              .is_less_than_or_equal_to(100)
              .is_greater_than_or_equal_to(0))
  end

  context 'calculating average' do
    let_it_be(:subject) { create(:project_evaluation_summary) }
    let_it_be(:a_evaluation_scores) { create_list(:evaluation_score, 2, total: 100, project_evaluation_summary: subject) }
    let_it_be(:b_evaluation_scores) { create_list(:evaluation_score, 2, total: 85, project_evaluation_summary: subject) }
    let_it_be(:c_evaluation_scores) { create_list(:evaluation_score, 2, total: 70, project_evaluation_summary: subject) }

    it 'should calculate it\'s own average properly' do
      subject.calculate_average!
      expect(subject.reload.average).to eq((100 + 85 + 70) / 3)
    end
  end
end
