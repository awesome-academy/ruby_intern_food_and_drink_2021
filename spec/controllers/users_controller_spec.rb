require "rails_helper"
include SessionsHelper

RSpec.describe UsersController, type: :controller do
  describe "GET #show" do
    let(:user) {FactoryBot.create :user}
    context "when not logged in" do
      before do
        get :show, params: {locale: I18n.locale, id: user.id}
      end

      it "redirect to the login" do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is logged in" do
      before do
        sign_in user
        get :show, params: {id: user.id}
      end

      it "assigns @user" do
        expect(assigns(:user)).to eq user
      end

      it "render show" do
        expect(response).to render_template(:show)
      end
    end

    context "when is invalid" do
      before do
        sign_in user
        get :show, params: {id: Settings.id_fail}
      end

      it "show flash danger" do
        expect(flash[:danger]).to eq I18n.t("user_not_found")
      end
      it "redirect to the root" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
