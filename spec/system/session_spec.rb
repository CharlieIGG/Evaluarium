# frozen_string_literal: true

RSpec.describe 'Login', type: :system do
  context 'log in' do
    context 'should be succesful' do
      user = FactoryBot.create(:user)
      visit new_user_session_path
      within('form') do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: '12345678'
        click_on('Log in')
      end
      expect(current_path).to eq root_path
    end

    context 'should fail' do
      user = FactoryBot.create(:user)
      visit new_user_session_path
      within('form') do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: '12345679'
        click_on('Log in')
      end
      expect(page).to have_content('Log in')
    end
  end
end
