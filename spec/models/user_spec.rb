# frozen_string_literal: true

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
