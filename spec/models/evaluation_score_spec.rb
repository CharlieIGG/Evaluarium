# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EvaluationScore, type: :model do
  it { should belong_to :project_evaluation_summary }
  it { should belong_to :evaluation_criterium }
end
