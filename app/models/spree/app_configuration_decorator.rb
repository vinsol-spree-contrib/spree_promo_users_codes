Spree::AppConfiguration.class_eval do
  preference :codes_per_page, :integer, default: 15
end
