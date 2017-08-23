module Spree
  class Promotion::Code < Spree::Base
    self.table_name = :spree_promotion_codes

    with_options required: true do
      belongs_to :promotion, class_name: 'Spree::Promotion'
      belongs_to :user, class_name: Spree.user_class.to_s, foreign_key: :user_id
    end

    validates :code, presence: true
    validates :user, uniqueness: { scope: :promotion_id }, allow_blank: :true
    validate :code_uniqueness

    private
      def code_uniqueness
        if Spree::Promotion.with_coupon_code(code).present?
          errors.add(:code, Spree.t(:already_present, scope: :promotion_code))
        end
      end
  end
end
