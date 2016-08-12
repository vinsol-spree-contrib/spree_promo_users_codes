class AddCodeToSpreeOrderPromotions < ActiveRecord::Migration
  def change
    add_column :spree_orders_promotions, :code, :string
  end
end
