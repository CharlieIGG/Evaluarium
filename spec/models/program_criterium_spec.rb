# frozen_string_literal: true

# == Schema Information
#
# Table name: program_criteria
#
#  id                      :bigint           not null, primary key
#  evaluation_program_id   :bigint           not null
#  evaluation_criterium_id :bigint           not null
#  position                :integer
#  weight                  :float
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#


require 'rails_helper'

RSpec.describe ProgramCriterium, type: :model do
  subject { create(:program_criterium) }
  it { should belong_to :evaluation_criterium }
  it { should belong_to :evaluation_program }
  it { should validate_uniqueness_of(:evaluation_criterium_id).scoped_to(:evaluation_program_id) }
end
