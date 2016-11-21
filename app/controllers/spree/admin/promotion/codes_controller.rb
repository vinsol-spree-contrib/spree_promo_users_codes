module Spree
  module Admin
    module Promotion
      class CodesController < ResourceController
        belongs_to 'spree/promotion'

        private
          def model_class
            "Spree::Promotion::#{ controller_name.classify }".constantize
          end

          def permitted_resource_params
            params.require(:code).permit(:code, :user_id)
          end

          def collection_url
            admin_promotion_codes_path(@promotion)
          end
      end
    end
  end
end
