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
    let(:current_user) { create(:user, :superadmin) }

    it 'can invite a new user successfully' do
      visit new_user_invitation_path
      fill_in 'Email', with: 'some.valid@email.com'
      click_on I18n.t('devise.invitations.new.submit_button')
    end

    it 'can see all users' do
      create_list(:user, 5)
      visit users_path
      user_rows = all('.rspec_users_table tbody tr')
      expect(user_rows.count).to eq(6) # 5 created + 1 admin user
    end

    context 'managing a specific user' do
      let!(:user) { create(:user, email: 'zzz@zzz.com') }

      it 'can delete a user', js: true do
        visit users_path
        within find('.rspec_users_table tr', text: user.email) do
          click_on 'Actions'
        end
        expect do
          click_on 'Delete'
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content('successfully deleted')
        end.to(change(User, :count).by(-1))
      end

      it 'can go to edit a user', js: true do
        visit users_path
        user_rows = all('.rspec_users_table tbody tr')
        within user_rows.last do
          click_on 'Actions'
        end
        click_on 'Edit'
        expect(current_path).to eq(edit_user_path(user))
      end

      it 'can edit a user' do
        new_email = 'new@email.com'
        visit edit_user_path(user)
        fill_in 'Email', with: new_email
        click_on 'Update User'
        expect(current_path).to eq(users_path)
        expect(user.reload.email).to eq(new_email)
      end
    end
  end
end
