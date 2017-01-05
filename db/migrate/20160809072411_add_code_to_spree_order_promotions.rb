class AddCodeToSpreeOrderPromotions < ActiveRecord::Migration
  def change
    add_column :spree_order_promotions, :code, :string
  end
end
