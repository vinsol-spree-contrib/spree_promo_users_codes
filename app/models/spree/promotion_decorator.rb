Spree::Promotion.class_eval do
  has_many :codes, class_name: 'Spree::Promotion::Code', dependent: :destroy
  has_many :promotable_users, through: :codes, source: :user

  def self.with_coupon_code(coupon_code, user = nil)
    code = coupon_code.to_s.strip.downcase
    promotions = joins('LEFT JOIN spree_promotion_codes ON spree_promotions.id = spree_promotion_codes.promotion_id')
    if user
      promotions.find_by("(lower(spree_promotions.code) = ? AND spree_promotions.multi_coupon = ?) OR (lower(spree_promotion_codes.code) = ? AND spree_promotions.multi_coupon = ? AND spree_promotion_codes.user_id = ?)", code, false, code, true, user.id)
    else
      promotions.find_by("(lower(spree_promotions.code) = ? AND spree_promotions.multi_coupon = ?) OR (lower(spree_promotion_codes.code) = ? AND spree_promotions.multi_coupon = ?)", code, false, code, true)
    end
  end

  def eligible?(promotable)
    return false if (expired? || usage_limit_exceeded?(promotable) || blacklisted?(promotable)) || !multi_coupon_eligible?(promotable)
    !!eligible_rules(promotable, {})
  end

  private

    def multi_coupon_eligible?(promotable)
      multi_coupon? ? authorized?(promotable) : true
    end

    def authorized?(promotable)
      promotable_order = promotable.is_a?(Spree::Order) ? promotable : promotable.order
      promotable_user, coupon_code = promotable_order.user, promotable_order.coupon_code
      already_included_in_order = promotable_order.promotions.include?(self) || promotable_order.all_adjustments.eligible.promotion.any? { |adjustment| adjustment.source.promotion == self }

      if coupon_code.blank? || codes.where("user_id = ? AND lower(code) = ?", promotable_user.try(:id), coupon_code).exists?
        if already_included_in_order
          promotable_user && promotable_users.include?(promotable_user)
        else
          promotable_user && promotable_users.include?(promotable_user) && !codes.where(user: promotable_user, used: true).exists?
        end
      else
        false
      end
    end
end
