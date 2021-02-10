require 'rails_helper'

describe Promotion do
  context 'validation' do
    it 'attributes cannot be blank' do
      promotion = Promotion.new
      
      expect(promotion.valid?).to eq false
      expect(promotion.errors.count).to eq 7
    
    end

    it 'description is optional' do
      user = User.create!(email: 'joao@email.com', password: '123456')
      promotion = Promotion.new(name: 'Natal', description: '',
                        code: 'NAT', coupon_quantity: 10, discount_rate: 10,
                         expiration_date: '2021-10-10', user: user)
      
      expect(promotion.valid?).to eq true
    end
    
    it 'error messages are in portuguese' do
      promotion = Promotion.new

      promotion.valid?

      expect(promotion.errors[:user]).to include('é obrigatório(a)')
      expect(promotion.errors[:name]).to include('não pode ficar em branco')
      expect(promotion.errors[:code]).to include('não pode ficar em branco')
      expect(promotion.errors[:discount_rate]).to include('não pode ficar em '\
                                                          'branco')
      expect(promotion.errors[:coupon_quantity]).to include('não pode ficar em'\
                                                            ' branco')
      expect(promotion.errors[:expiration_date]).to include('não pode ficar em'\
                                                            ' branco')
    end

    it 'code must be uniq' do
      user = User.create!(email: 'joao@email.com', password: '123456')

      Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10,
                        coupon_quantity: 100, expiration_date: '22/12/2033', user: user)
      promotion = Promotion.new(code: 'NATAL10')

      promotion.valid?

      expect(promotion.errors[:code]).to include('já está em uso')
    end

    it 'coupons cannot be edited to be lower in case they are already emitted' do
      user = User.create!(email: 'joao@email.com', password: '123456')

      promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10,
                        coupon_quantity: 10, expiration_date: '22/12/2033', user: user)
      promotion.generate_coupons!
      promotion.coupon_quantity = 5
      promotion.valid?

      expect(promotion.reload.coupon_quantity).to eq 10
      expect(promotion.errors[:coupon_quantity]).to include('deve ser maior ou igual a 10')
    end

  end

  context '#generate_coupons!' do
    it 'generate_coupons of coupon_quantity' do
      user = User.create!(email: 'joao@email.com', password: '123456')

      promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

      promotion.generate_coupons!

      expect(promotion.coupons.size).to eq 100
      expect(promotion.coupons.pluck(:code)).to include('NATAL10-0001')
      expect(promotion.coupons.pluck(:code)).to include('NATAL10-0100')
      expect(promotion.coupons.pluck(:code)).not_to include('NATAL10-0000')
      expect(promotion.coupons.pluck(:code)).not_to include('NATAL10-0101')
    end

    it 'do not generate if error' do
      user = User.create!(email: 'joao@email.com', password: '123456')

      promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
      promotion.coupons.create!(code: 'NATAL10-0010')
      
      expect{promotion.generate_coupons!}.to raise_error(ActiveRecord::RecordNotUnique)
      expect(promotion.coupons.reload.size).to eq 1
    end

    xit 'do not generate if coupons for the promotion already exists' do
      user = User.create!(email: 'joao@email.com', password: '123456')

      promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 10,
                                  expiration_date: '22/12/2033', user: user)
      promotion.generate_coupons!
      promotion.coupon_quantity = 20
      promotion.generate_coupons!
      expect(promotion.coupons.size).to eq 20
    end
  end

  context '#approve' do
    it 'should generate a PromotionApproval object' do
      promotion_owner = User.create!(email: 'joao@email.com', password: '123456')
      promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                    expiration_date: '22/12/2033', user: promotion_owner)
        
      approval_user = User.create!(email: 'henrique@email.com', password: '123456') 

      promotion.approve!(approval_user)

      promotion.reload
      expect(promotion.approved?).to be_truthy
      expect(promotion.approver).to eq approval_user
    end

    it 'should not approve if same user' do
      promotion_owner = User.create!(email: 'joao@email.com', password: '123456')
      promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                    expiration_date: '22/12/2033', user: promotion_owner)

      promotion.approve!(promotion_owner)
      promotion.reload
      expect(promotion.approved?).to be_falsy
    end
  end
end
