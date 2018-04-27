Spree::Order.class_eval do

  state_machine.after_transition to: :complete, do: :update_used_for_promotion_code

  def update_used_for_promotion_code
    promotion_ids = all_adjustments.promotion.eligible.map { |a| a.source.promotion_id }
    promotion = promotions.where(id: promotion_ids).where(multi_coupon: true).last
    if promotion.present?
      promotion_code = promotion.codes.where(user_id: user_id).last
      promotion_code.update_columns(used: true)
    end
  end

end
