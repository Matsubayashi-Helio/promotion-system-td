require 'rails_helper'

feature 'User search for a promotion' do
    scenario 'successfully' do
        promotion_owner = User.create!(email: 'joao@email.com', password: '123456')
        
        promotionNatal = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                    expiration_date: '22/12/2033', user: promotion_owner)
        
        promotionBlackFriday = Promotion.create!(name: 'Black Friday', description: 'Promoção de Black Friday',
                                    code: 'BLACK15', discount_rate: 15, coupon_quantity: 50,
                                    expiration_date: '22/12/2033', user: promotion_owner)

        promotionDiaDasMaes = Promotion.create!(name: 'Dia das Mães', description: 'Promoção de Dia das Mães',
                                    code: 'MAES15', discount_rate: 15, coupon_quantity: 100,
                                    expiration_date: '22/12/2033', user: promotion_owner)

        login_as promotion_owner
        visit root_path
        click_on 'Promoções'
        fill_in 'Busca', with: 'Friday'
        click_on 'Pesquisar'

        expect(current_path).to eq search_promotions_path
        # expect(page).to have_content('Natal')
        # expect(page).to have_content('NATAL10')
        expect(page).to have_content('Black Friday')
        expect(page).to have_content('BLACK15')
        # expect(page).to have_content('Dia das Mães')
        # expect(page).to have_content('MAES15')


    end
end