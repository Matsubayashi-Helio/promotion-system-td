require 'rails_helper'

feature 'Admin view categories' do
    scenario 'successfully' do
        Category.create!(name: 'Smartphones', code: 'SMART')

        visit root_path
        click_on 'Categorias'

        expect(page).to have_content('Smartphones')
        expect(page).to have_content('SMART')
    end
end