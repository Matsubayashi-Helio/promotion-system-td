class HomeController < ApplicationController
    def index
    end
    
    def search
        @coupons = Coupon.where('code like ?', "%#{params[:q]}%")

        # unless @coupons.any?
        #     notice: 'Cupom não existe!'
        # end
    end
    
end