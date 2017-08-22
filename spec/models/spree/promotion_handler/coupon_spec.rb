require 'spec_helper'


describe Spree::PromotionHandler::Coupon, type: :model do
  let(:order) { FactoryGirl.create(:completed_order_with_pending_payment) }
  let(:promotion) { Spree::Promotion.create!(name: "new promotion", multi_coupon: true) }
  let(:promotion_code) { promotion.codes.create!(code: 'test', user: order.user) }

  before do
    promotion_code
    order.coupon_code = promotion_code.code
    order.promotions << promotion
    coupon = Spree::PromotionHandler::Coupon.new(order)
    coupon.update_used_for_promotion_code
  end

  describe '#update_used_for_promotion_code' do
    it { expect(promotion_code.reload).to be_used }
  end
end
