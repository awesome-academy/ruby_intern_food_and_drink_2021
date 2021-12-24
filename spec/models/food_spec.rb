require "rails_helper"

RSpec.describe Food, type: :model do
  describe "associations" do
    it { should belong_to(:category) }
    it { should have_many(:carts).dependent(:destroy) }
    it { should have_many(:orders).through(:carts) }
    it { should have_one_attached(:thumbnail) }
    it { should have_many_attached(:images) }
    it { should accept_nested_attributes_for(:category).allow_destroy(true) }
  end

  describe "Scope" do
    let!(:category_1){FactoryBot.create :category}
    let!(:category_2){FactoryBot.create :category}
    let!(:food_1){FactoryBot.create :food, category_id: category_1.id}
    let!(:food_2){FactoryBot.create :food, name: "Dâu"}
    let!(:food_3){FactoryBot.create :food}

    context "with scope recent_foods" do
      it "return list recent foods order by create at DESC" do
        expect(Food.recent_foods).to eq([food_3,food_2,food_1])
      end
    end

    context "with scope search_by_name" do
      it "search food by name" do
        expect(Food.search_by_name("Dâu")).to eq [food_2]
      end

      it "when not found food" do
        expect(Food.search_by_name("timsaoduoc")).to eq []
      end
    end

    context "with scope find_foods_cart" do
      it "return food with id = 2" do
        expect(Food.find_foods_cart(food_2.id)).to eq [food_2]
      end

      it "when not found food by id" do
        expect(Food.find_foods_cart(Settings.id_fail)).to eq []
      end
    end

    context "with scope filter_category" do
      it "return food with ctegory_id = 1" do
        expect(Food.filter_category(category_1.id)).to eq [food_1]
      end

      it "when not found food by category_id" do
        expect(Food.filter_category(category_2.id)).to eq []
      end

      it "when not found category" do
        expect(Food.filter_category(Settings.id_fail)).to eq []
      end
    end
  end

  describe "Delegate category" do
    it { should delegate_method(:category_name).to(:category) }
  end

  describe "Enum" do
    it { should define_enum_for(:status) }
  end

  describe "Validations" do
    context "with field name" do
      it { should validate_presence_of(:name) }

      it { should validate_length_of(:name).is_at_most(Settings.len_max) }
    end

    context "with field price" do
      it { should validate_presence_of(:price) }

      it { should validate_numericality_of(:price) }

      it { should allow_value(0).for(:price) }

      it { should_not allow_value(-1).for(:price) }
    end

    context "with field description" do
      it { should validate_presence_of(:description) }

      it { should validate_length_of(:description).is_at_least(Settings.len_min) }

      it { should validate_length_of(:description).is_at_most(Settings.len_max_des) }
    end

    context "with field quantity" do
      it { should validate_presence_of(:quantity) }

      it { should validate_numericality_of(:quantity).only_integer }

      it { should allow_value(0).for(:quantity) }

      it { should_not allow_value(-1).for(:quantity) }
    end
  end
end
