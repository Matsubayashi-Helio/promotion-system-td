class RenameCoupomDiscountToCouponDiscount < ActiveRecord::Migration[6.1]
  def change
    rename_column :promotions, :coupom_quantity, :coupon_quantity
  end
end
