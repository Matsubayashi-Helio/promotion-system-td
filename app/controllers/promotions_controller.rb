class PromotionsController < ApplicationController
    before_action :authenticate_user!


    def index
        @promotions = Promotion.all
    end

    def show
        @promotion = Promotion.find(params[:id])
    end

    def new
        @promotion = Promotion.new
    end

    def create
        @promotion = Promotion.new(promotion_params)
        # @promotion.name = params[:promotion][:name]
        # @promotion.description = params[:promotion][:description]
        # @promotion.code = params[:promotion][:code]
        # @promotion.discount_rate = params[:promotion][:discount_rate]
        # @promotion.coupon_quantity = params[:promotion][:coupon_quantity]
        # @promotion.expiration_date = params[:promotion][:expiration_date]
        @promotion.user = current_user
        if @promotion.save
            redirect_to promotion_path(id: @promotion.id)
        else
            render 'new'
        end
    end

    def generate_coupons
        promotion = Promotion.find(params[:id])
        promotion.generate_coupons!
        redirect_to promotion, notice: t('.success')
    end

    def edit
        @promotion = Promotion.find(params[:id])
    end

    def update
        @promotion = Promotion.find(params[:id])

        if @promotion.update(promotion_params)
            redirect_to promotion_path @promotion
        else
            render 'edit'
        end
    end

    def destroy
        @promotion = Promotion.find(params[:id])
        @promotion.destroy

        redirect_to promotions_path
    end


    def approve
        promotion = Promotion.find(params[:id])
        promotion.approve!(current_user)
        # PromotionApproval.create(promotion: promotion, user: current_user)
        redirect_to promotion
    end

    def search
        @promotions = Promotion.where('name like ? OR code like ?', "%#{params[:q]}%", "%#{params[:q]}%")
    end



    private
        def promotion_params
            params.require(:promotion).permit(:name, :description, :code, :discount_rate, :coupon_quantity, :expiration_date)
        end
end 