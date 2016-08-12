class AddHasManyCodesToSpreePromotions < ActiveRecord::Migration
  def change
    add_column :spree_promotions, :has_many_codes, :boolean, default: false
  end
end
