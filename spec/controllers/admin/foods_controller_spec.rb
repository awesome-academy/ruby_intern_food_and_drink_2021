require "rails_helper"

RSpec.describe Admin::FoodsController, type: :controller do
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

      context "when has permission, show food DESC" do
        let!(:user) {FactoryBot.create :user, role: true}
        let!(:food_1) {FactoryBot.create :food}
        let!(:food_2) {FactoryBot.create :food}
        before do
          sign_in user
          get :index
        end

        it "assigns @foods" do
          expect(assigns(:foods)).to eq [food_2, food_1]
        end
      end
    end
  end

  describe "when logged in and has permission" do
    let(:user) {FactoryBot.create :user, role: true}
    before do
      sign_in user
    end
    describe "GET #new" do
      before do
        get :new
      end
      it "renders the template new" do
        expect(response).to render_template :new
      end
    end

    describe "POST #create" do
      context "when invalid params" do
        before do
          post :create, params: { food: { name: "" }}
        end
        it "render new" do
          expect(response).to render_template :new
        end
        it "display flash" do
          expect(flash[:danger]).to eq I18n.t("add_fail")
        end
      end
    end

    describe "GET #show" do
      let(:food) {FactoryBot.create :food}
      context "when food not found" do
        before do
          get :show, params: {id: Settings.id_fail}
        end

        it "display flash danger" do
          expect(flash[:danger]).to eq I18n.t("show_failer")
        end
        it "redirect to admin foods path" do
          expect(response).to redirect_to admin_foods_path
        end
      end

      context "when food exist" do
        before do
          get :show, params: {id: food.id}
        end

        it "assigns @food" do
          expect(assigns(:food)).to eq food
        end
        it "renders the template show" do
          expect(response).to render_template :show
        end
      end
    end

    describe "GET #edit" do
      let(:food) {FactoryBot.create :food}
      context "when food not found" do
        before do
          get :show, params: {id: Settings.id_fail}
        end

        it "display flash danger" do
          expect(flash[:danger]).to eq I18n.t("show_failer")
        end
        it "redirect to admin foods path" do
          expect(response).to redirect_to admin_foods_path
        end
      end

      context "when food exist" do
        before do
          get :edit, params: {id: food.id}
        end

        it "assigns @food" do
          expect(assigns(:food)).to eq food
        end
        it "renders the template show" do
          expect(response).to render_template :edit
        end
      end
    end
  end
end
