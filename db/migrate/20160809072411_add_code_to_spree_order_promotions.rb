class AddCodeToSpreeOrderPromotions < SpreeExtension::Migration[4.2]
  def change
    add_column :spree_order_promotions, :code, :string
  end
end
