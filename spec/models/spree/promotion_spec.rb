require "spec_helper"

describe Spree::Promotion, type: :model do
  let(:user) { create :user }
  let(:promotion) do
    promotion = Spree::Promotion.create(name: 'test_promotion', multi_coupon: true)
    promotion.codes.create(code: 'test', user: user)
    promotion
  end
  let(:multi_promotion_code) { 'multi' }

  describe 'associations' do
    it { is_expected.to have_many(:codes).class_name('Spree::Promotion::Code').dependent(:destroy) }
  end

  describe 'methods' do
    describe "#eligible?" do
      let(:promotable) { create :order, user: user }

      subject { promotion.eligible?(promotable) }

      context "when promotion is expired" do
        before { promotion.expires_at = Time.now - 10.days }
        it { is_expected.to be false }
      end

      context "when promotable is a Spree::LineItem" do
        let(:order) { create :order, user: user }
        let(:promotable) { create(:line_item, order: order) }
        let(:product) { promotable.product }
        before do
          product.promotionable = promotionable
        end
        context "when product is promotionable" do
          let(:promotionable) { true }
          it { is_expected.to be true }

          context 'when multi_coupon is false' do
            before do
              promotion.multi_coupon = false
            end
            it { is_expected.to be true }
          end
        end

        context "when product is not promotionable" do
          let(:promotionable) { false }
          it { is_expected.to be false }

          context 'when multi_coupon is false' do
            before do
              promotion.multi_coupon = false
            end
            it { is_expected.to be false }
          end
        end
      end

      context "when promotable is a Spree::Order" do
        let(:promotable) { create :order, user: user }
        context "when it is empty" do
          before do
            promotion.save
          end
          it { is_expected.to be true }

          context 'when multi_coupon is false' do
            before do
              promotion.multi_coupon = false
            end
            it { is_expected.to be true }
          end
        end

        context "when it contains items" do
          let!(:line_item) { create(:line_item, order: promotable) }
          context "when the items are all non-promotionable" do
            before do
              line_item.product.update_column(:promotionable, false)
            end
            it { is_expected.to be false }
          end

          context "when at least one item is promotionable" do
            before do
              line_item.product.update_column(:promotionable, true)
            end
            it { is_expected.to be true }

            context 'when multi_coupon is false' do
              before do
                promotion.multi_coupon = false
              end
              it { is_expected.to be true }
            end

            context 'when code is already used' do
              before do
                promotion.codes.first.update_column(:used, true)
              end
              it { is_expected.to be false }
            end
          end
        end
      end
    end

    describe '.with_coupon_code' do
      let(:promotion) { Promotion.create(name: "At line items", code: 'test') }
      let(:multi_promotion) do
        promotion = Spree::Promotion.create(multi_coupon: true, code: multi_promotion_code)
        promotion.codes.build(code: 'test2', user: user)
        promotion
      end

      context 'when code is present on spree_promotions' do
        it 'user to return promotion' do
          expect {
            Spree::Promotion.with_coupon_code(test).to eq(promotion)
          }
        end
      end

      context 'when code is present on spree_promotion_codes' do
        it 'user to return promotion' do
          expect {
            Spree::Promotion.with_coupon_code(test).to eq(promotion)
          }
        end
      end

      context 'when code of the master promotion is applied' do
        it 'does not return the promotion' do
          expect {
            Spree::Promotion.with_coupon_code(multi_promotion_code).to be_nil
          }
        end
      end

    end
  end
end
