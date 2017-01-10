FactoryGirl.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_promo_users_codes/factories'

  FactoryGirl.define do
    factory :promotion_code, class: Spree::Promotion::Code do
      code { |n| "code-#{n}" }
      promotion
      user
    end
  end
end
