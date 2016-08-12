Spree::Order.class_eval do
  has_many :order_promotions, class_name: Spree::OrderPromotion

  def promotion_codes
    order_promotions.pluck(:code)
  end
end