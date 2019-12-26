# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string
#  invited_by_id          :bigint
#  invitations_count      :integer          default(0)
#  name                   :string
#  phone                  :string
#  position               :string
#


require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build_stubbed(:user) }
  it 'can have many roles' do
    expect(subject.respond_to?(:roles)).to eq(true)
    subject.add_role :some_role
    expect(subject.roles.count).to eq(1)
    expect(subject.has_role?(:some_role)).to eq(true)
  end
end
