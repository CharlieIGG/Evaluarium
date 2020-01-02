# frozen_string_literal: true

# == Schema Information
#
# Table name: evaluation_programs
#
#  id                          :bigint           not null, primary key
#  name                        :string           not null
#  start_at                    :datetime         not null
#  end_at                      :datetime
#  program_type                :integer          default("project_follow_up"), not null
#  score_calculation_method    :integer          not null
#  calculation_inclusion_count :integer
#  calculation_inclusion_unit  :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  criteria_scale_max          :float            not null
#  criteria_scale_min          :float            not null
#  criteria_step_size          :float            default(1.0), not null
#


require 'rails_helper'

RSpec.describe EvaluationProgram, type: :model do
  subject { create(:evaluation_program) }
  it { should have_many(:project_evaluations) }
  it { should have_many(:projects).through(:project_evaluations) }
  it { should have_many(:program_criteria) }
  it { should have_many(:evaluation_criteria).through(:program_criteria) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:criteria_scale_max) }
  it { should validate_presence_of(:criteria_scale_min) }
  it { should validate_presence_of(:criteria_step_size) }

  it 'should validate consistency between the boundaries of the Criteria Scale' do
    subject.criteria_scale_max = 10
    subject.criteria_scale_min = 100
    expect(subject).not_to be_valid

    subject.criteria_scale_max = 10
    subject.criteria_scale_min = 0
    expect(subject).to be_valid
  end

  it 'should not allow for step-sizes too big for the scale' do
    subject.criteria_scale_max = 5
    subject.criteria_step_size = 10
    expect(subject).not_to be_valid

    subject.criteria_step_size = 5
    expect(subject).not_to be_valid

    subject.criteria_step_size = 2.5
    expect(subject).to be_valid
  end

  it 'should not allow for step-sizes that would prevent users from reaching\
      the Maximum value' do
    subject.criteria_scale_max = 24
    subject.criteria_step_size = 7
    expect(subject).not_to be_valid
    subject.criteria_step_size = 6
    expect(subject).to be_valid
    subject.criteria_step_size = 5
    expect(subject).not_to be_valid
    subject.criteria_step_size = 4
    expect(subject).to be_valid
    subject.criteria_step_size = 3
    expect(subject).to be_valid
    subject.criteria_step_size = 2
    expect(subject).to be_valid
    subject.criteria_step_size = 1
    expect(subject).to be_valid
  end
end
