require "rails_helper"

RSpec.describe OrdersController, type: :controller do
  describe "GET #index" do
    let!(:user) {FactoryBot.create :user}
    context "when not logged in" do
      before do
        get :index, params: {locale: I18n.locale, user_id: user.id}
      end

      it "redirect to the login" do
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "when logged in" do
      context "show order DESC" do
        let!(:user) {FactoryBot.create :user}
        let!(:order_1) {FactoryBot.create :order, user_id: user.id}
        let!(:order_2) {FactoryBot.create :order, user_id:user.id}
        let!(:order_3) {FactoryBot.create :order}
        before do
          sign_in user
          get :index, params: {user_id: user.id}
        end

        it "assigns @orders" do
          expect(assigns(:orders)).to eq [order_2, order_1]
        end
      end
    end
  end

  describe "GET #new" do
    let!(:user) {FactoryBot.create :user}
    before do
      sign_in user
      session[:cart] = {}
      get :new, params: {user_id: user.id}
    end

    context "when cart empty" do
      it "redirect to root_url" do
        expect(response).to redirect_to root_path
      end
      it "display flash danger" do
        expect(flash[:danger]).to eq I18n.t("cart_empty")
      end
    end

    context "when cart any item" do
      let!(:food) {FactoryBot.create :food}
      before do
        session_params = { food.id.to_s => Settings.quantity_min }
        session[:cart] = session_params
        get :new, params: { user_id: user.id, session: session_params }
      end

      it "assigns @carts" do
        @carts = Food.find_foods_cart(session[:cart].keys)
        expect(assigns(:carts)).to eq @carts
      end
      it "renders template new" do
        expect(response).to render_template :new
      end
    end
  end

  describe "POST #create" do
    let!(:user) {FactoryBot.create :user}
    let!(:food) {FactoryBot.create :food}
    before do
      sign_in user
      session[:cart] = {}
    end

    context "when user input address, phone and submit" do
      before do
        session_params = {food.id.to_s => Settings.quantity_min}
        session[:cart] = session_params
        post :create, params: {
          user_id: user.id,
          address: "Quan Chung , Ha Noi",
          phone: "0909090909",
          session: session_params
        }
      end

      it "flash display success" do
        expect(flash[:success]).to eq I18n.t("order_success")
      end
      it "redirect to user_orders" do
        expect(response).to redirect_to user_orders_path(user)
      end
    end
    context "when user not input address, phone and submit" do
      before do
        session_params = {food.id.to_s => Settings.quantity_min}
        session[:cart] = session_params
        post :create, params: {
          user_id: user.id,
          address: "",
          phone: "",
          session: session_params
        }
      end

      it "flash display danger" do
        expect(flash[:danger]).to eq I18n.t("order_fail")
      end
      it "redirect to user_orders" do
        expect(response).to redirect_to user_orders_path(user)
      end
    end
  end

  describe "GET #show" do
    let(:user) {FactoryBot.create :user}
    let!(:order) {FactoryBot.create :order, user_id: user.id}
    before do
      sign_in user
    end

    context "when order exist" do
      let!(:food) {FactoryBot.create :food}
      let!(:cart) {
        FactoryBot.create :cart,
        order_id: order.id,
        food_id: food.id
      }
      before do
        @order = user.orders.find_by id: order.id
        @carts = order.carts.includes(:food)
        get :show, params: {user_id: order.user.id, id: order.id}
      end

      it "assigns @order" do
        expect(assigns(:order)).to eq @order
      end
      it "assigns @carts" do
        expect(assigns(:carts)).to eq @carts
      end
      it "renders template show" do
        expect(response).to render_template :show
      end
    end

    context "when order not exist" do
      before do
        get :show, params: {
          user_id: user.id,
          id: Settings.id_fail
        }
      end

      it "redirect to root_url" do
        expect(response).to redirect_to root_url
      end
      it "display flash danger" do
        expect(flash[:danger]).to eq I18n.t("no_order")
      end
    end
  end

  describe "PUT #update" do
    let!(:user) {FactoryBot.create :user}
    let!(:order) {FactoryBot.create :order, status: :open, user_id: user.id}
    before do
      sign_in order.user
    end

    context "when order status open" do
      before do
        put :update, params: {user_id: order.user.id, id: order.id }
      end
      it "display flash success" do
        expect(flash[:success]).to eq I18n.t("order_changed")
      end
      it "redirect to user_order" do
        expect(response).to redirect_to user_order_path
      end
    end

    context "when status not open" do
      before do
        order.cancelled!
        put :update, params: {user_id: order.user.id, id: order.id }
      end
      it "display flash danger" do
        expect(flash[:danger]).to eq I18n.t("update_fail")
      end
      it "redirect to root_url" do
        expect(response).to redirect_to user_order_path
      end
    end
  end
end
