module Spree
  module Admin
    module Promotion
      class CodesController < ResourceController
        before_action :load_promotion, only: :index

        private
          def model_class
            "Spree::Promotion::#{ controller_name.classify }".constantize
          end

          def permitted_resource_params
            params.require(:code).permit(:code).merge({ user_id: params[:customer_search], promotion_id: params[:promotion_id] })
          end

          def load_promotion
            @promotion ||= Spree::Promotion.find_by(id: params[:promotion_id])
            redirect_to admin_promotions_path, alert: Spree.t(:no_promotions_found) unless @promotion.present?
          end
      end
    end
  end
end
