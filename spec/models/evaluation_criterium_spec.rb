# frozen_string_literal: true

# == Schema Information
#
# Table name: evaluation_criteria
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#


require 'rails_helper'

RSpec.describe EvaluationCriterium, type: :model do
  it { should have_many(:program_criteria) }
  it { should have_many(:evaluation_programs).through(:program_criteria) }
  it { should have_many(:project_evaluation_summaries).through(:evaluation_programs) }
  it { should validate_uniqueness_of(:name) }
end
