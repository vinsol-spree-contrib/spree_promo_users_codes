Spree::Order.class_eval do

  state_machine.after_transition to: :complete, do: :update_multi_coupon_codes

  def update_multi_coupon_codes
    multi_coupon_promotions = create_line_item_promotions + adjustment_promotions
    multi_coupon_promotions.each { |promotion| update_used_for_promotion_code(promotion) }
  end

  private

    def adjustment_promotions
      promotion_ids = all_adjustments.promotion.eligible.map { |adjustment| adjustment.source.promotion_id }
      promotions.where(id: promotion_ids).where(multi_coupon: true).uniq
    end

    def create_line_item_promotions
      promotions.where(multi_coupon: true).joins(:promotion_actions).where(spree_promotion_actions: { type: 'Spree::Promotion::Actions::CreateLineItems' })
    end

    def update_used_for_promotion_code(promotion)
      if promotion.present?
        promotion_code = promotion.codes.where(user_id: user_id).last
        promotion_code.update_columns(used: true)
      end
    end

end
