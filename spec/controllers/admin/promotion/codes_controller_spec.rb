require 'spec_helper'

describe Spree::Admin::Promotion::CodesController, type: :controller do
  stub_authorization!

  describe '#index' do
    let(:user) { mock_model(Spree::User, id: 1) }
    let(:promotion) { mock_model(Spree::Promotion, id: 1) }
    let(:code) { mock_model(Spree::Promotion::Code, user: user, promotion: promotion) }
    let(:codes) { [code] }

    before do
      allow(controller).to receive(:spree_current_user).and_return(user)
      allow(Spree::Promotion).to receive(:find_by).and_return(promotion)
    end

    def send_request(params = {})
      spree_get :index, params
    end

    context 'when promotion found' do
      it 'expects to assign promotion' do
        send_request(promotion_id: promotion.id)
        expect(assigns(:promotion)).to eq(promotion)
      end

      it 'expects to render template index' do
        send_request(promotion_id: promotion.id)
        expect(response).to render_template :index
      end
    end

    context 'when promotion not found' do
      before do
        allow(Spree::Promotion).to receive(:find_by).and_return(nil)
      end

      it 'expects not to assign promotion' do
        send_request(promotion_id: promotion.id)
        expect(assigns(:promotion)).to eq(nil)
      end

      it 'expects to redirect' do
        send_request(promotion_id: promotion.id)
        expect(response).to redirect_to(spree.admin_promotions_path)
      end

      it 'expects set flash' do
        send_request(promotion_id: promotion.id)
        expect(flash[:alert]).to eq("No promotions found")
      end

      )
    end
  end
end
