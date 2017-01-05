module Spree
  module PromotionHandler
    module CartOverride
      private
        def promotions
          super.reject { |promotion| promotion.multi_coupon }
        end
    end
  end
end
