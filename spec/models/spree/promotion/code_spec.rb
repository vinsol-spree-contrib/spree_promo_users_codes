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
    it { is_expected.to validate_uniqueness_of(:code) }
    it { is_expected.to validate_uniqueness_of(:user) }
  end
end
