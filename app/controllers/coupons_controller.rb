class CouponsController < ApplicationController
    # before_action :check_coupons

    def inactivate
        @coupon = Coupon.find(params[:id])
        redirect_to @coupon.promotion, notice('Coupon is already inactive!') if @coupon.inactive?
        @coupon.inactive!
        redirect_to @coupon.promotion
    end

    # private
    #     def check_coupons
    #         @coupon = Coupon.find(params[:id])
    #         redirect_to '/app/public/422.html' if @coupon.inactive?
    #     end
end