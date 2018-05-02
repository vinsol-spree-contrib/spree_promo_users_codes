Spree::Order.class_eval do

  state_machine.after_transition to: :complete, do: :update_multi_coupon_codes

  def update_multi_coupon_codes
    promotion_ids = all_adjustments.promotion.eligible.map { |a| a.source.promotion_id }
    promotions_applied = promotions.where(id: promotion_ids).where(multi_coupon: true).uniq
    promotions_applied.each { |promotion| update_used_for_promotion_code(promotion) }
    update_used_for_promotion_code(create_line_item_promotion)
  end

  private

    def create_line_item_promotion
      promotions.joins(:promotion_actions).where(spree_promotion_actions: { type: 'Spree::Promotion::Actions::CreateLineItems' }).last
    end

    def update_used_for_promotion_code(promotion)
      if promotion.present?
        promotion_code = promotion.codes.where(user_id: user_id).last
        promotion_code.update_columns(used: true)
      end
    end

end
