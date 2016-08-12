class CreateSpreePromotionCodes < ActiveRecord::Migration
  def change
    create_table :spree_promotion_codes do |t|
      t.references :promotion, index: true
      t.string :code
      t.datetime :deactivation_time
    end
  end
end
