require 'spec_helper'

module Spree
  module PromotionHandler
    describe Cart, type: :model do
      let(:line_item) { create(:line_item) }
      let(:order) { line_item.order }

      let(:promotion) { Promotion.create(name: "At line items") }
      let(:multi_promotion) { create :promotion, multi_coupon: true }
      let(:calculator) { Calculator::FlatPercentItemTotal.new(preferred_flat_percent: 10) }

      subject { Cart.new(order, line_item) }

      context '#promotions' do
        subject { subject.send(:promotions) }

        context 'when promitons is called' do
          before do
            simple_promotions = [promotion]
            multi_promotions = [multi_promotion]
          end
          it 'shows not multi promotions' do
            expect { subject.send(:promotions) }.to eq simple_promotions
          end
        end
      end
    end
  end
end
