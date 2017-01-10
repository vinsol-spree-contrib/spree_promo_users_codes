Spree::PromotionHandler::Coupon.class_eval do
  def determine_promotion_application_result
    detector = lambda { |p|
      source_promotion = p.source.promotion
      if source_promotion.multi_coupon? && order.user && source_promotion.codes.present?
        source_promotion.codes.where(user: order.user, code: order.coupon_code.downcase).present?
      elsif source_promotion.code
        source_promotion.code.downcase == order.coupon_code.downcase
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
      update_used_for_promotion_code
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

  def update_used_for_promotion_code
    promotion = order.promotions.with_coupon_code(order.coupon_code)
    if promotion.multi_coupon?
      promotion_code = promotion.codes.find_by(code: order.coupon_code)
      promotion_code.update_column(:used, true)
    end
  end
end
