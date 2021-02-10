require 'rails_helper'

RSpec.describe Coupon, type: :model do
  context 'Test request' do
    xit 'inactive coupon and cannot access' do
        user = User.create!(email: 'joao@email.com', password: '123456')
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 10,
                                    expiration_date: '22/12/2033', user: user)
        coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion, status: inactive)
        # promotion.generate_coupons!

        post inactivate_coupon_path, params: {id: coupon}
        expect(response).to #block request?
        
    end
  end
end
