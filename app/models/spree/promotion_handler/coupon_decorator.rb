module Spree
  module PromotionHandler
    Coupon.class_eval do
      def apply
        if order.coupon_code.present?
          if promotion.present? && promotion.actions.exists?
            promotion.expired?(order.code) ? (set_error_code :coupon_code_expired) : handle_present_promotion(promotion)
          else
            set_error_code :coupon_code_not_found
          end
        end

        self
      end

      def promotion
        @promotion ||= Promotion.includes(:promotion_rules, :promotion_actions).with_coupon_code(order.coupon_code)
      end
    end
  end
end
