require 'rails_helper'

feature 'Admin registers a category' do
    scenario 'from index page' do
        visit root_path
        click_on 'Categoria'

        expect(page).to have_link('Registrar uma categoria', href: new_category_path)
    end

    scenario 'successfully' do
        visit root_path
        click_on 'Categorias'
        click_on 'Registrar uma categoria'

        fill_in 'Nome', with: 'Smartphones'
        fill_in 'Código', with: 'SMART'
        click_on 'Criar categoria'

        expect(current_path).to eq(category_path(Category.last))
        expect(page).to have_content('Smartphones')
        expect(page).to have_content('SMART')
        expect(page).to have_link('Voltar')
    end

    scenario 'attributes cannot be blank' do
        visit root_path
        click_on 'Categorias'
        click_on 'Registrar uma categoria'
        fill_in 'Nome', with: ''
        fill_in 'Código', with: ''
        click_on 'Criar categoria'

        
        expect(page).to have_content('Não foi possível criar a categoria')
        expect(page).to have_content('Nome não pode ficar em branco')
        expect(page).to have_content('Código não pode ficar em branco')
        expect(Category.count).to eq 0
    end

    scenario 'code must be unique' do
        Category.create!(name: 'Smartphones', code: 'SMART')

        visit root_path
        click_on 'Categorias'
        click_on 'Registrar uma categoria'
        fill_in 'Código', with: 'SMART'
        click_on 'Criar categoria'

        expect(page).to have_content('Código já está em uso')
    end

end