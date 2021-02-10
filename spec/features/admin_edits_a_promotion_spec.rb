require 'rails_helper'

feature 'Admin edits a promotion' do
    scenario 'and visit edit link' do
        user = User.create!(email: 'joao@email.com', password: '123456')

        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
        login_as user
        visit root_path
        click_on 'Promoções'
        click_on 'Natal'

        expect(page).to have_link('Editar Promoção', href: edit_promotion_path(promotion))     
    end

    scenario 'and attributes cannot be blank' do
        user = User.create!(email: 'joao@email.com', password: '123456')

        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
        login_as user
        visit root_path
        click_on 'Promoções'
        click_on 'Natal'
        click_on 'Editar Promoção'
        
        fill_in 'Nome', with: ''
        fill_in 'Descrição', with: ''
        fill_in 'Código', with: ''
        fill_in 'Desconto', with: ''
        fill_in 'Quantidade de cupons', with: ''
        fill_in 'Data de término', with: ''
        click_on 'Editar promoção'

        expect(Promotion.count).to eq 1
        expect(page).to have_content('Não foi possível editar a promoção')
        expect(page).to have_content('Nome não pode ficar em branco')
        expect(page).to have_content('Código não pode ficar em branco')
        expect(page).to have_content('Desconto não pode ficar em branco')
        expect(page).to have_content('Quantidade de cupons não pode ficar em branco')
        expect(page).to have_content('Data de término não pode ficar em branco')

    end

    scenario 'and code must be unique' do
        user = User.create!(email: 'joao@email.com', password: '123456')

        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
        
        Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user)
        login_as user            
        visit root_path
        click_on 'Promoções'
        click_on 'Cyber Monday'
        click_on 'Editar Promoção'
        fill_in 'Código', with: 'NATAL10'
        click_on 'Editar promoção'

        expect(page).to have_content('Código já está em uso')

    end

    scenario 'successfully' do
        user = User.create!(email: 'joao@email.com', password: '123456')
        Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user)

        login_as user
        visit root_path
        click_on 'Promoções'
        click_on 'Cyber Monday'
        click_on 'Editar Promoção'
        fill_in 'Nome', with: 'Segunda-feira da Tecnologia'
        fill_in 'Descrição', with: 'Promoção Cyber Monday com até 10% de desconto'
        fill_in 'Código', with: 'CYBER10'
        fill_in 'Desconto', with: '10'
        fill_in 'Quantidade de cupons', with: '90'
        fill_in 'Data de término', with: '31/12/2050'
        click_on 'Editar promoção'

        expect(page).to have_content('Segunda-feira da Tecnologia')
        expect(page).to have_content('Promoção Cyber Monday com até 10% de desconto')
        expect(page).to have_content('CYBER10')
        expect(page).to have_content('10')
        expect(page).to have_content('90')
        expect(page).to have_content('31/12/2050')

    end
end