require "rails_helper"

RSpec.describe Admin::CategoriesController, type: :controller do
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

      context "when has permission, show categories" do
        let!(:user) {FactoryBot.create :user, role: true}
        let!(:category_1) {FactoryBot.create :category}
        let!(:category_2) {FactoryBot.create :category}
        before do
          sign_in user
          get :index
        end

        it "assigns @categorys" do
          expect(assigns(:categories)).to eq [category_1, category_2]
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
    end

    describe "POST #create" do
      context "when valid params" do
        before do
          post :create, params: { category: {
            category_name: "chicken"
          }}
        end
        it "display success" do
          expect(flash[:success]).to eq I18n.t("add_success")
        end
        it "redirect to the admin_categories_path" do
          expect(response).to redirect_to admin_categories_path
        end
      end

      context "when invalid params" do
        before do
          post :create, params: { category: { name: "" }}
        end
        it "display flash" do
          expect(flash[:danger]).to eq I18n.t("add_fail")
        end
        it "redirect to the admin_categories_path" do
          expect(response).to redirect_to admin_categories_path
        end
      end
    end

    describe "DELETE #destroy" do
      let(:category) {FactoryBot.create :category}
      context "when category not found" do
        before do
          get :destroy, params: {id: Settings.id_fail}
        end

        it "display flash danger" do
          expect(flash[:danger]).to eq I18n.t("delete_fail")
        end
        it "redirect to admin admin_categories_path" do
          expect(response).to redirect_to admin_categories_path
        end
      end

      context "when category exist" do
        before do
          get :destroy, params: {id: category.id}
        end
        it "display flash success" do
          expect(flash[:success]).to eq I18n.t("category_deleted")
        end
        it "redirect to admin admin_categories_path" do
          expect(response).to redirect_to admin_categories_path
        end
      end
    end
  end
end
