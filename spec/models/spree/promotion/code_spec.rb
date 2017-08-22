require "spec_helper"

describe Spree::Promotion::Code, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:promotion).class_name('Spree::Promotion') }
    it { is_expected.to belong_to(:user).class_name('Spree::User').with_foreign_key(:user_id) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:promotion).with_message(:required) }
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:user).with_message(:required) }

    context 'promotion_id uniqueness to user' do
      let!(:promotion1) { FactoryGirl.create(:promotion) }
      let!(:promotion2) { FactoryGirl.create(:promotion) }
      let!(:user) { FactoryGirl.create(:user) }
      let!(:promotion_code1) { FactoryGirl.create(:promotion_code, promotion: promotion1, user: user) }

      it { expect(FactoryGirl.build(:promotion_code, promotion: promotion1, user: user)).to be_invalid }
      it { expect(FactoryGirl.build(:promotion_code, promotion: promotion2, user: user)).to be_valid }
    end

    context '#code_uniqueness' do
      let(:user) { create :user }
      let(:old_promotion) { Spree::Promotion.create(code: 'test') }
      let(:new_promotion) do
        promotion = Spree::Promotion.create(multi_coupon: true, name: 'new promotion')
        promotion.codes.create(code: 'test', user: user)
        promotion
      end

      before do
        old_promotion
        new_promotion
        @code = new_promotion.codes.first
      end

      it 'expect record to be invalid' do
        expect{ @code.valid?.to be false }
      end

      it 'adds errors' do
        @code.valid?
        expect(@code.errors[:code]).to eq([Spree.t(:already_present, scope: :promotion_code)])
      end
    end
  end
end
