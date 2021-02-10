require 'rails_helper'

feature 'Admin edits a category' do
    scenario 'and visit edit link' do
        visit root_path
        click_on 'Categorias'
        click_on 'Registrar uma categoria'

        fill_in 'Nome', with: 'Disco Rígido'
        fill_in 'Código', with: 'HDD'
        click_on 'Criar categoria'

        category = Category.find_by(code: 'HDD')

        # get :edit, id: category.id

        expect(page).to have_link('Editar Categoria', href: edit_category_path(id: category.id))
        # expect(current_path).to eq edit_category_path(id: category.id)
    end

    scenario 'and cannot be blank' do
        Category.create!(name: 'Disco Rígido', code: 'HDD')

        visit root_path
        click_on 'Categorias'
        click_on 'Disco Rígido'
        click_on 'Edit'
        fill_in 'Nome', with: ''
        click_on 'Editar Categoria'

        # something along the lines of 
        # expect(Category.last).not_to have_content(Name: 'Disco Rígido Interno')
        expect(page).to have_content('Não foi possível editar a categoria')
        expect(page).to have_content('Nome não pode ficar em branco')
    end

    scenario 'and code must be unique' do
        Category.create!(name: 'Disco Rígido', code: 'HDD')
        Category.create!(name: 'HD Externo', code: 'XHDD')

        visit root_path
        click_on 'Categorias'
        click_on 'HD Externo'
        click_on 'Edit'
        fill_in 'Código', with: 'HDD'
        click_on 'Editar Categoria'


        expect(page).to have_content('Não foi possível editar a categoria')
        expect(page).to have_content('Código já está em uso')

        #Something along the lines of
        # expect(Category.last).not_to have_content(code: 'HDD')


    end

    scenario 'successfully' do
        Category.create!(name: 'Disco Rígido', code: 'HDD')

        visit root_path
        click_on 'Categorias'
        click_on 'Disco Rígido'
        click_on 'Edit'
        fill_in 'Nome', with: 'Disco Rígido Interno'
        click_on 'Editar Categoria'

        expect(page).to have_content('Disco Rígido Interno')
        expect(page).to have_content('HDD')
    end

end
