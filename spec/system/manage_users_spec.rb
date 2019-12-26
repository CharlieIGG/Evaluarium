# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Manage Users', type: :system do
  let(:current_user) { create(:user) }

  signed_in_as :current_user

  context 'As a random user' do
    context 'Trying to do anything' do
      it 'should be bounced back to root' do
        visit new_user_invitation_path
        expect(current_path).to eq(root_path)
      end
    end
  end
  context 'As a Superadmin' do
    let(:current_user) { create(:user) }
    context 'Add a new user' do
      it 'can invite a new user successfully' do
        visit new_user_invitation_path
        fill_in 'Email', with: 'some.valid@email.com'
        click_on I18n.t('devise.invitations.new.submit_button')
      end
    end
  end
end
