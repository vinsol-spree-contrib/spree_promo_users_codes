unless defined? Spree::OrderPromotion
  class Spree::OrderPromotion < ActiveRecord::Base
    self.table_name = 'spree_orders_promotions'
  end
end
