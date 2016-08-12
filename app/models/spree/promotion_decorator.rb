Spree::Promotion.class_eval do
  has_many :codes, class_name: Spree::PromotionCode
  attr_accessor :current_code

  def expired?(code=nil)
    if has_many_codes && code
      promotion_code  = get_code(code)
      promotion_code_expired? = promotion_code.expired? if promotion_code
    end
    (starts_at && Time.now < starts_at || expires_at && Time.now > expires_at) || promotion_code_expired?
  end

  def get_code(code)
    codes.find_by(code: code)
  end

  def self.with_coupon_code(coupon_code)
    code = coupon_code.strip.downcase
    joins(:codes).where("lower(#{self.table_name}.code) = ? OR lower(#{Spree::PromotionCode.table_name}.code) = ?", code, code).first
  end
end