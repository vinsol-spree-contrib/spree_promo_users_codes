Spree::Promotion.class_eval do
  has_many :codes, class_name: Spree::Promotion::Code, dependent: :destroy

  def self.with_coupon_code(coupon_code)
    code = coupon_code.strip.downcase
    joins(:codes).where("lower(#{self.table_name}.code) = ? OR lower(#{Spree::Promotion::Code.table_name}.code) = ?", code, code).first
  end

  def support_multiple_coupon?
    multi_coupon?
  end

  def eligible?(promotable)
    return false if (expired? || usage_limit_exceeded?(promotable) || blacklisted?(promotable)) ||  !multi_coupon_eligible?(promotable)
    !!eligible_rules(promotable, {})
  end


  private

    def multi_coupon_eligible?(promotable)
      support_multiple_coupon? ? authorized?(promotable) : false
    end

    def authorized?(promotable)
      case promotable
      when Spree::LineItem
        promotable.order.user && promotable_users.include?(promotable.order.user)
      when Spree::Order
        promotable.user && promotable_users.include?(promotable.user)
      end
    end

    def promotable_users
      @promotable_users ||= codes.map(&:user)
    end
end
