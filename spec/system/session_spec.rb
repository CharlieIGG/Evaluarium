# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login', type: :system do
  context 'log in' do
    context 'with valid data' do
      let(:user) { FactoryBot.create(:user) }
      it 'should be succesful' do
        visit new_user_session_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: '12345678'
        click_on('Log in')
        expect(current_path).to eq root_path
      end
    end
    context 'with invalid data' do
      it 'should fail' do
        visit new_user_session_path
        fill_in 'Email', with: 'non-existent@email.com'
        fill_in 'Password', with: '12345679'
        click_on('Log in')
        expect(page).to have_content('Log in')
      end
    end
  end
end
