require 'rails_helper'

feature 'Admin approves a promotion' do
    scenario 'and must be signed in' do
        user = User.create!(email: 'joao@email.com', password: '123456')
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                    expiration_date: '22/12/2033', user: user)
        visit promotion_path(promotion)

        expect(current_path).to eq new_user_session_path
    end

    scenario 'must not be promotion creator' do
        promotion_owner = User.create!(email: 'joao@email.com', password: '123456')
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                    expiration_date: '22/12/2033', user: promotion_owner)
        
       other_user = User.create!(email: 'henrique@email.com', password: '123456')                             


       login_as promotion_owner, scope: :user
       visit promotion_path(promotion)

       expect(page).not_to have_link('Aprovar Promoção')

    end

    scenario 'must be another user' do
        promotion_owner = User.create!(email: 'joao@email.com', password: '123456')
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                    expiration_date: '22/12/2033', user: promotion_owner)
        
       other_user = User.create!(email: 'henrique@email.com', password: '123456')                             


       login_as other_user, scope: :user
       visit promotion_path(promotion)

       expect(page).to have_link('Aprovar Promoção')
    end

    scenario 'successfully' do
        promotion_owner = User.create!(email: 'joao@email.com', password: '123456')
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                    expiration_date: '22/12/2033', user: promotion_owner)
        
       approval_user = User.create!(email: 'henrique@email.com', password: '123456')  

       login_as approval_user, scope: :user
       visit promotion_path(promotion)
       click_on 'Aprovar Promoção'

       promotion.reload
       expect(current_path).to eq promotion_path(promotion)
       expect(promotion.approved?).to be_truthy
       expect(promotion.approver).to eq approval_user
       expect(page).to have_content('Status: Aprovada')
    end
end