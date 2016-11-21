Spree::Promotion.class_eval do
  has_many :codes, class_name: Spree::Promotion::Code, dependent: :destroy
  has_many :promotable_users, through: :codes, source: :user

  def self.with_coupon_code(coupon_code)
    code = coupon_code.strip.downcase
    joins(:codes).where("lower(#{self.table_name}.code) = ? OR lower(#{Spree::Promotion::Code.table_name}.code) = ?", code, code).first
  end

  def eligible?(promotable)
    return false if (expired? || usage_limit_exceeded?(promotable) || blacklisted?(promotable)) ||  !multi_coupon_eligible?(promotable)
    !!eligible_rules(promotable, {})
  end


  private

    def multi_coupon_eligible?(promotable)
      multi_coupon? ? authorized?(promotable) : false
    end

    def authorized?(promotable)
      promotable_user  = promotable.try(:user) || promotable.try(:order).try(:user)
      case promotable
      when Spree::LineItem
        promotable_user && promotable_users.include?(promotable_user)
      when Spree::Order
        promotable_user && promotable_users.include?(promotable_user)
      end
    end
end
