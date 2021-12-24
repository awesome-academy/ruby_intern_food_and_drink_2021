require "rails_helper"

RSpec.describe Admin::OrdersController, type: :controller do
  describe "GET #index" do
    let!(:user) {FactoryBot.create :user, role: false}
    context "when not logged in" do
      before do
        get :index, params: {locale: I18n.locale}
      end

      it "redirect to login" do
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "when logged in" do
      context "when not permission" do
        let!(:user) {FactoryBot.create :user, role: false}
        before do
          sign_in user
          get :index
        end

        it "display flash danger" do
          expect(flash[:danger]).to eq I18n.t("not_permission")
        end
        it "redirect to root_url" do
          expect(response).to redirect_to root_url
        end
      end

      context "when has permission, show order DESC" do
        let!(:user) {FactoryBot.create :user, role: true}
        let!(:order_1) {FactoryBot.create :order}
        let!(:order_2) {FactoryBot.create :order}
        before do
          sign_in user
          get :index
        end

        it "assigns @orders" do
          expect(assigns(:orders)).to eq [order_2, order_1]
        end
      end
    end
  end

  describe "when logged in and has permission" do
    let(:user) {FactoryBot.create :user, role: true}
    before do
      sign_in user
    end
    describe "GET #show" do
      let(:order) {FactoryBot.create :order, user_id: user.id}
      context "when order not found" do
        before do
          get :show, params: {id: Settings.id_fail}
        end

        it "display flash danger" do
          expect(flash[:danger]).to eq I18n.t("no_order")
        end
        it "redirect to admin orders" do
          expect(response).to redirect_to admin_orders_path
        end
      end

      context "when order exist" do
        let!(:carts) {FactoryBot.create :cart, order_id: order.id}
        before do
          get :show, params: {id: order.id}
        end

        it "assigns @order" do
          expect(assigns(:order)).to eq order
        end
        it "assigns  @carts" do
          expect(assigns(:carts)).to eq [carts]
        end
        it "renders the template show" do
          expect(response).to render_template :show
        end
      end
    end

    describe "PUT #approve" do
      context "when order status open" do
        let(:order) {FactoryBot.create :order, status: :open}
        before do
          put :approve, params: {id: order.id}
        end

        it "display flash success" do
          expect(flash[:success]).to eq I18n.t("approve_success")
        end
        it "redirect to admin orders" do
          expect(response).to redirect_to root_path
        end
      end

      context "when order status completed" do
        let(:order) {FactoryBot.create :order, status: :completed}
        before do
          put :approve, params: {id: order.id}
        end

        it "display flash danger" do
          expect(flash[:danger]).to eq I18n.t("approve_failed")
        end
        it "redirect to root" do
          expect(response).to redirect_to root_path
        end
      end
    end

    describe "PUT #reject" do
      context "when order status open" do
        let(:order) {FactoryBot.create :order, status: :open}
        before do
          get :reject, params: {id: order.id}
        end

        it "display flash success" do
          expect(flash[:success]).to eq I18n.t("reject_success")
        end
        it "redirect to admin orders" do
          expect(response).to redirect_to admin_orders_path
        end
      end

      context "when order status cancelledd" do
        let(:order) {FactoryBot.create :order, status: :cancelled}
        before do
          get :reject, params: {id: order.id}
        end

        it "display flash danger" do
          expect(flash[:danger]).to eq I18n.t("reject_failed")
        end
        it "redirect to admin orders" do
          expect(response).to redirect_to admin_orders_path
        end
      end
    end
  end
end
