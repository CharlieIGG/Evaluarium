# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  it { should have_many(:project_program_summaries) }
  it { should have_many(:evaluation_programs).through(:project_program_summaries) }
end
