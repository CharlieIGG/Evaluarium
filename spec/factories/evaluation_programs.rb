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

FactoryBot.define do
  factory :evaluation_program do
    sequence(:name) { |n| "Program #{n}" }
    criteria_scale_max { 5 }
    criteria_scale_min { 0 }
    criteria_step_size { 1 }
    start_at { '2019-11-13 01:04:14' }
    end_at { '2019-11-13 01:04:14' }
    program_type { :project_follow_up }
  end
end
