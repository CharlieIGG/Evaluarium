# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Manage Evaluation Criteria', type: :system do
  let_it_be(:current_user) { create(:user) }

  signed_in_as :current_user

  context 'As a random User' do
    context 'Trying to do anything' do
      it 'should be bounced back to root' do
        visit new_evaluation_criterium_path
        expect(current_path).to eq(root_path)
      end
    end
  end

  context 'As a Superadmin' do
    current_user_roles!([{ name: :superadmin }])

    it 'can invite a new Evaluation Criterium successfully', js: true do
      name = 'Some Name'
      description = 'Some Description'
      short_description = 'Some Short Description'

      visit new_evaluation_criterium_path
      fill_in 'Name', with: name
      fill_in 'Short description', with: short_description
      expect do
        click_on 'Create Evaluation Criterion'
      end.to change(EvaluationCriterium, :count).by(1)
      new_criterium = EvaluationCriterium.last
      expect(new_criterium.name).to eq(name)
      expect(new_criterium.short_description).to eq(short_description)
      # TODO: "ENABLE once ActionText::SystemTestHelper is added into 'stable' Rails"
      # expect(new_criterium.description.body.to_plain_text).to eq(description)
    end

    it 'can see all evaluation_criteria' do
      create_list(:evaluation_criterium, 5)
      visit evaluation_criteria_path

      evaluation_criterium_cards = all('.rspec_evaluation_criteria_list .card')
      expect(evaluation_criterium_cards.count).to eq(5)
    end

    context 'managing a specific evaluation_criterium' do
      let_it_be(:evaluation_criterium, reload: true) { create(:evaluation_criterium) }

      context 'deleting Evaluation Crtieria' do
        context 'without associated Programs' do
          it 'can delete a evaluation_criterium', js: true do
            pending 'Will finish this after adding Programs'
            expect(true).to be(false)
          end

          context 'with associated Programs' do
            it 'CANNOT delete a evaluation_criterium', js: true do
              pending 'Will finish this after adding Programs'
              expect(true).to be(false)
            end
          end
        end
      end

      it 'can go to edit a evaluation_criterium' do
        visit evaluation_criteria_path
        evaluation_criterium_cards = all('.rspec_evaluation_criteria_list .card')
        within evaluation_criterium_cards.last do
          click_on 'Edit'
        end
        expect(current_path).to eq(edit_evaluation_criterium_path(evaluation_criterium))
      end

      it 'can edit an Evaluation Criterium', js: true do
        new_name = 'NEW NAME'
        new_description = 'NEW DESCRIPTION'
        new_short_description = 'NEW SHORT DESCRIPTION'
        visit edit_evaluation_criterium_path(evaluation_criterium)
        fill_in 'Name', with: new_name
        fill_in 'Short description', with: new_short_description
        click_on 'Update Evaluation Criterion'
        expect(current_path).to eq(evaluation_criteria_path)
        expect(evaluation_criterium.reload.name).to eq(new_name)
        expect(evaluation_criterium.short_description).to eq(new_short_description)
        # TODO: "ENABLE once ActionText::SystemTestHelper is added into 'stable' Rails"
        # expect(evaluation_criterium.description.body.to_plain_text).to eq(new_description)
      end
    end
  end
end
