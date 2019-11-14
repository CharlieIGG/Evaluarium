# frozen_string_literal: true

RSpec.feature 'Manage Users', type: :system do
  context 'As a random user' do
    scenario 'Trying to do anything' do
      it 'should be bounced back to root' do
      end
    end
  end
  context 'As a Superadmin' do
    scenario 'Add a new user' do
    end
  end
end
