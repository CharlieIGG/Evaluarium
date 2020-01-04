# frozen_string_literal: true

# == Schema Information
#
# Table name: evaluation_scores
#
#  id                    :bigint           not null, primary key
#  program_criterium_id  :bigint           not null
#  project_evaluation_id :bigint           not null
#  total                 :float            default(0.0), not null
#  weighed_total         :float            default(0.0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'rails_helper'

RSpec.describe EvaluationScore, type: :model do
  subject { create(:evaluation_score) }
  it { should belong_to :project_evaluation }
  it { should belong_to :program_criterium }
  it { should have_one :evaluation_program }

  it { should validate_uniqueness_of(:program_criterium_id).scoped_to(:project_evaluation_id) }

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
    let(:evaluation_program) { create(:evaluation_program, criteria_scale_max: 100) }
    let(:criterium_weight) { 20 }
    let(:test_score) { create(:evaluation_score, evaluation_program: evaluation_program, criterium_weight: criterium_weight) }
    context 'on save' do
      it 'should calculate its own weighted_total correctly' do
        test_score.total = 100
        test_score.save!
        expect(test_score.reload.weighed_total).to eq(criterium_weight)
        test_score.total = 50
        test_score.save!
        expect(test_score.reload.weighed_total).to eq(0.5 * criterium_weight)
      end
    end
  end
end
