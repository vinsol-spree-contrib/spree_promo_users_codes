require "spec_helper"

describe Spree::Promotion::Code, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:promotion).class_name('Spree::Promotion') }
    it { is_expected.to belong_to(:user).class_name('Spree::User').with_foreign_key(:user_id) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:promotion) }
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:user) }
    it { expect(create(:promotion_code)).to validate_uniqueness_of(:user).scoped_to(:promotion).allow_blank }

    context '#code_uniqueness' do
      let(:user) { create :user }
      let(:promotion) do
        promotion = Spree::Promotion.create(multi_coupon: true)
        promotion.codes.create(code: 'test', user: user)
        promotion
      end

      before do
        new_promotion = Spree::Promotion.new(code: 'test')
      end

      it 'expect record to be invalid' do
        expect{ new_promotion.valid?.to be false }
      end
    end
  end
end
