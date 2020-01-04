# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id         :bigint           not null, primary key
#  name       :string
#  founded_at :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  it { should have_many(:project_evaluations) }
  it { should have_many(:project_program_summaries) }
  it { should have_many(:evaluation_programs).through(:project_program_summaries) }
end
