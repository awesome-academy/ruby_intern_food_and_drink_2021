require "rails_helper"

RSpec.describe Admin::UsersController, type: :controller do
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

      context "when has permission, show users" do
        let!(:user) {FactoryBot.create :user, role: true}
        let!(:user_1) {FactoryBot.create :user}
        before do
          sign_in user
          get :index
        end

        it "assigns @users" do
          expect(assigns(:users)).to eq [user, user_1]
        end
      end
    end
  end

  describe "when logged in and has permission" do
    let(:user) {FactoryBot.create :user, role: true}
    before do
      sign_in user
    end
    describe "PUT #update" do
      let!(:user_1) {FactoryBot.create :user, activated: false}
      context "when exit user" do
        before do
          put :update, params: {id: user_1.id }
        end
        it "display flash success" do
          expect(flash[:success]).to eq I18n.t("update_success")
        end
        it "redirect to user_order" do
          expect(response).to redirect_to admin_users_path
        end
      end

      context "when not exit user" do
        before do
          put :update, params: {id: Settings.id_fail }
        end
        it "display flash danger" do
          expect(flash[:danger]).to eq I18n.t("no_user")
        end
        it "redirect to root_url" do
          expect(response).to redirect_to admin_users_path
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:user_2) {FactoryBot.create :user}
      context "when user not found" do
        before do
          get :destroy, params: {id: Settings.id_fail}
        end

        it "display flash danger" do
          expect(flash[:danger]).to eq I18n.t("no_user")
        end
        it "redirect to admin admin_users_path" do
          expect(response).to redirect_to admin_users_path
        end
      end

      context "when user exist" do
        before do
          get :destroy, params: {id: user_2.id}
        end
        it "display flash success" do
          expect(flash[:success]).to eq I18n.t("update_success")
        end
        it "redirect to admin admin_users_path" do
          expect(response).to redirect_to admin_users_path
        end
      end
    end
  end
end
