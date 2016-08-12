class Spree::PromotionCode < ActiveRecord::Base
  belongs_to :promotion, class_name: Spree::Promotion
  validates :promotion, :code, presence: true
  validates :code, uniqueness: true

  scope :active, -> { where('deactivates_at IS NULL OR deactivates_at > ?', Time.now) }

  def self.generate_unique_codes(promotion, count=1,  prefix=nil)
    prefix = (promotion.code.presence || promotion.name.presence) if prefix.nil?
    last_code_id = last.try(:id) || 1
    codes ||= []

    new_codes_count = 0

    while(new_codes_count < count) do
      code = prefix + last_code_id.to_s
      new_promotion_code = promotion.codes.create(code: code)

      if new_promotion_code.persisted?
        new_codes_count += 1
        codes << new_promotion_code
      end

      last_code_id += 1
    end

    return ((count <= 1) ? codes.first : codes)
  end


  def deactivated?
    deactivates_at && Time.now > deactivates_at
  end
end
