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

FactoryBot.define do
  factory :evaluation_criterium do
    name { "MyString" }
    description { "MyText" }
  end
end
