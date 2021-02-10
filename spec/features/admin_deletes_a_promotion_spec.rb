require 'rails_helper'

feature 'Admin deletes a promotion' do
    scenario 'and visit delete link' do
        user = User.create!(email: 'joao@email.com', password: '123456')

        
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                    expiration_date: '22/12/2033', user: user)

        login_as user
        visit root_path
        click_on 'Promoções'
        click_on 'Natal'

        expect(page).to have_link('Deletar Promoção', href: promotion_path(promotion))
    end

    scenario 'successfully' do
        user = User.create!(email: 'joao@email.com', password: '123456')
        Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
        login_as user
        visit root_path
        click_on 'Promoções'
        click_on 'Natal'
        click_on 'Deletar Promoção'
        
        expect(Promotion.count).to eq 0
    end
end