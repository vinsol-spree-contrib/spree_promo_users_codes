Spree::PromotionHandler::Cart.class_eval do
  prepend Spree::PromotionHandler::CartOverride
end
