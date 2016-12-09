module Spree
  module PromotionHandler
    module CartOverride
      private
        def promotions
          promo_table = Promotion.arel_table
          super.where(promo_table[:multi_coupon].eq(false))
        end
    end
  end
end
