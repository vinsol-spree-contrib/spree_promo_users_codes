module Spree
  module Admin
    class CodesController < ResourceController
      belongs_to 'spree/promotion'

      private
        def model_class
          Spree::Promotion::Code
        end

        def permitted_resource_params
          params.require(:code).permit(:code, :user_id)
        end

        def collection_url
          admin_promotion_codes_path(@promotion)
        end

        def collection
          super.page(params[:page])
               .per(params[:per_page] || Spree::Config[:codes_per_page])
        end
    end
  end
end
