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

FactoryBot.define do
  factory :program_criterium do
    evaluation_program { nil }
    evaluation_criteria { nil }
    position { 1 }
    weight { 1.5 }
  end
end
