module Spree
  class Promotion::Code < ActiveRecord::Base
    self.table_name = :spree_promotion_codes

    belongs_to :promotion, class_name: Spree::Promotion
    belongs_to :user, class_name: Spree.user_class, foreign_key: 'user_id'
    validates :promotion, :code, :user, presence: true
    validates :code, :user, uniqueness: true
  end
end
