require "rails_helper"

RSpec.describe FoodsController, type: :controller do
  describe "GET #index" do
    let!(:category_1){FactoryBot.create :category}
    let!(:category_2){FactoryBot.create :category}
    let!(:food_1){FactoryBot.create :food, category_id: category_1.id}
    let!(:food_2){FactoryBot.create :food, name: "Dâu", category_id: category_1.id}
    let!(:food_3){FactoryBot.create :food, category_id: category_2.id}
    context "when the input name is valid" do
      before do
        get :index, params: {name: food_2.name}
      end
      it "assigns @foods" do
        expect(assigns(:foods)).to eq [food_2]
      end
      it "render the template shop" do
        expect(response).to render_template "static_pages/shop"
      end
    end

    context "when the input name is invalid" do
      before do
        get :index, params: {name: Settings.id_fail}
      end
      it "render the template menu" do
        expect(response).to render_template "static_pages/shop"
      end
    end

    context "when the category is invalid" do
      before do
        get :index, params: {category_id: category_2.id}
      end
      it "assigns @foods" do
        expect(assigns(:foods)).to eq [food_3]
      end
      it "render the template menu" do
        expect(response).to render_template "static_pages/shop"
      end
    end

    context "when the input name is invalid" do
      before do
        get :index, params: {category_id: Settings.id_fail}
      end
      it "render the template menu" do
        expect(response).to render_template "static_pages/shop"
      end
    end

    context "when without input name" do
      before do
        get :index
      end
      it "assigns @foods" do
        expect(assigns(:foods)).to eq [food_3, food_2, food_1]
      end
      it "render the template menu" do
        expect(response).to render_template "static_pages/shop"
      end
    end
  end

  describe "GET #show" do
    let!(:food) {FactoryBot.create :food}

    context "when food exist" do
      before do
        get :show, params: {id: food.id}
      end
      it "assigns @food" do
        expect(assigns(:food)).to eq food
      end
      it "renders the show template" do
        expect(response).to render_template :show
      end
    end

    context "when food not found" do
      before do
        get :show, params: {id: Settings.id_fail}
      end
      it "display flash danger" do
        expect(flash[:danger]).to eq I18n.t("show_food_fail")
      end
      it "redirect to the root_url" do
        expect(response).to redirect_to root_url
      end
    end
  end
end
