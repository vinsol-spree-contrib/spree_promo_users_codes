Spree::PromotionHandler::Coupon.class_eval do
  def determine_promotion_application_result
    detector = lambda { |p|
      source_promotion = p.source.promotion
      if source_promotion.multi_coupon? && order.user && source_promotion.codes.present?
        source_promotion.codes.where("user_id = ? AND LOWER(code) = ?", order.user.id, order.coupon_code.downcase).present?
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
      set_success_code :coupon_code_applied
    else
      # if the promotion exists on an order, but wasn't found above,
      # we've already selected a better promotion
      if order.promotions.with_coupon_code(order.coupon_code, order.user)
        set_error_code :coupon_code_better_exists
      else
        # if the promotion was created after the order
        set_error_code :coupon_code_not_found
      end
    end
  end

  def promotion_exists_on_order?
    if promotion.multi_coupon?
      applicable_multi_coupon = promotion.codes.where(user: order.user, used: true).first
      (order.promotions.include? promotion) && applicable_multi_coupon && (applicable_multi_coupon.code.downcase == order.coupon_code.try(:downcase))
    else
      order.promotions.include? promotion
    end
  end

end
