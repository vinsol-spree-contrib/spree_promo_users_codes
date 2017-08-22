class AddHasManyCodesToSpreePromotions < SpreeExtension::Migration[4.2]
  def change
    add_column :spree_promotions, :multi_coupon, :boolean, default: false, null: false
  end
end
