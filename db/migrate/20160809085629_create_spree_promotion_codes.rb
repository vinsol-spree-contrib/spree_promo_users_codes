class CreateSpreePromotionCodes < SpreeExtension::Migration[4.2]
  def change
    create_table :spree_promotion_codes do |t|
      t.references :promotion, index: true
      t.string :code
      t.integer :user_id
      t.boolean :used, default: false
      t.timestamps null: false
    end
  end
end
