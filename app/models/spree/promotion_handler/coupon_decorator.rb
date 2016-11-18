Spree::PromotionHandler::Coupon.class_eval do
  def determine_promotion_application_result
    detector = lambda { |p|
      if p.source.promotion.support_multiple_coupon? && order.user && p.source.promotion.codes.present?
        p.source.promotion.codes.where(user: order.user, code: order.coupon_code.downcase).present?
      elsif p.source.promotion.code
        p.source.promotion.code.downcase == order.coupon_code.downcase
      end
    }

    # Check for applied adjustments.
    discount = order.line_item_adjustments.promotion.detect(&detector)
    discount ||= order.shipment_adjustments.promotion.detect(&detector)
    discount ||= order.adjustments.promotion.detect(&detector)

    # Check for applied line items.
    created_line_items = promotion.actions.detect { |a| a.type == 'Spree::Promotion::Actions::CreateLineItems' }

    if (discount && discount.eligible) || created_line_items
      order.update_totals
      order.persist_totals
      set_success_code :coupon_code_applied
    else
      # if the promotion exists on an order, but wasn't found above,
      # we've already selected a better promotion
      if order.promotions.with_coupon_code(order.coupon_code)
        set_error_code :coupon_code_better_exists
      else
        # if the promotion was created after the order
        set_error_code :coupon_code_not_found
      end
    end
  end
end
