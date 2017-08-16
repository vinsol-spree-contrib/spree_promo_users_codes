require 'spec_helper'


describe Spree::PromotionHandler::Cart, type: :model do
  let(:line_item) { create(:line_item) }
  let(:order) { line_item.order }

  let(:promotion) { Spree::Promotion.create(name: "At line items") }
  let(:multi_promotion) { Spree::Promotion.create(name: "At line items", multi_coupon: true) }

  let(:calculator) { Spree::Calculator::FlatPercentItemTotal.new(preferred_flat_percent: 10) }

  subject { Spree::PromotionHandler::Cart.new(order, line_item) }

  context "activates in LineItem level" do
    let!(:action) { Spree::Promotion::Actions::CreateItemAdjustments.create(promotion: promotion, calculator: calculator) }
    let(:adjustable) { line_item }

    shared_context "creates the adjustment" do
      it "creates the adjustment" do
        expect {
          subject.activate
        }.to change { adjustable.adjustments.count }.by(1)
      end
    end

    context "promotion with no rules" do
      include_context "creates the adjustment"
    end

    context "promotion includes item involved" do
      let!(:rule) { Spree::Promotion::Rules::Product.create(products: [line_item.product], promotion: promotion) }

      include_context "creates the adjustment"
    end

    context "promotion has item total rule" do
      let(:shirt) { create(:product) }
      let!(:rule) { Spree::Promotion::Rules::ItemTotal.create(preferred_operator_min: 'gt', preferred_amount_min: 50, preferred_operator_max: 'lt', preferred_amount_max: 150, promotion: promotion) }

      before do
        # Makes the order eligible for this promotion
        order.item_total = 100
        order.save
      end

      include_context "creates the adjustment"
    end
  end

  context "activates in Order level" do
    let!(:action) { Spree::Promotion::Actions::CreateAdjustment.create(promotion: promotion, calculator: calculator) }
    let(:adjustable) { order }

    shared_context "creates the adjustment" do
      it "creates the adjustment" do
        expect {
          subject.activate
        }.to change { adjustable.adjustments.count }.by(1)
      end
    end
  end

  context "activates promotions associated with the order" do
    let(:promo) { create :promotion_with_item_adjustment, adjustment_rate: 5, code: 'promo' }
    let(:multi_promo) { create :promotion_with_item_adjustment, adjustment_rate: 5, code: '', multi_coupon: true }

    let(:adjustable) { line_item }

    before do
      order.promotions << [promo, multi_promo]
    end

    it "creates the adjustment" do
      expect {
        subject.activate
      }.to change { adjustable.adjustments.count }.by(1)
    end
  end
end
