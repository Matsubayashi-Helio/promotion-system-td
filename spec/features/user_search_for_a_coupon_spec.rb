require 'rails_helper'

feature 'User search for a coupon' do
    scenario 'successfully' do
        promotion_owner = User.create!(email: 'joao@email.com', password: '123456')
        
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 10,
                                    expiration_date: '22/12/2033', user: promotion_owner)
        promotion.generate_coupons!

        login_as promotion_owner
        visit root_path
        fill_in 'Buscar Cupom', with: 'NATAL10-0005'
        click_on 'Pesquisar'

        expect(current_path).to eq search_path
        expect(page).to have_content('NATAL10-0005')
        expect(page).to have_content('Natal')
        expect(page).to have_content('Status: Active')
    end

    scenario 'and does not exists' do
        user = User.create!(email: 'joao@email.com', password: '123456')

        login_as user
        visit root_path
        fill_in 'Buscar Cupom', with: 'NATAL-0001'
        click_on 'Pesquisar'

        expect(page).to have_content('Cupom não existe!')
        
    end
end