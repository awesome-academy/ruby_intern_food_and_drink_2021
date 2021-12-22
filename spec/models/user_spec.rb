require "rails_helper"

RSpec.describe User, type: :model do
  describe "Associations" do
    it "has many orders" do
      should have_many(:orders).dependent(:destroy)
    end
  end

  describe "validates" do
    subject { FactoryBot.create :user, email: "chung@gmail.com" }
    context "with field name" do
      it { should validate_presence_of(:name) }

      it { should validate_length_of(:name).is_at_least(Settings.len_min) }

      it { should validate_length_of(:name).is_at_most(Settings.len_max) }
    end

    context "with field email" do
      it { should validate_presence_of(:email) }

      it { should validate_uniqueness_of(:email).case_insensitive }

      it "when too short is invalid" do
        should_not allow_value("an").for(:email)
      end

      it "when email valid" do
        should allow_value("chung@gmail.com").for(:email)
      end
    end

    context "with field phone" do
      it { should validate_presence_of(:phone) }

      it { should validate_length_of(:phone).is_at_least(Settings.len_min) }
    end

    context "with field address" do
      it { should validate_presence_of(:address) }

      it { should validate_length_of(:address).is_at_least(Settings.len_min) }
    end

    context "with field password" do
      it { should validate_presence_of(:password).allow_nil }

      it { should validate_length_of(:password).is_at_least(Settings.len_min) }

      it { should validate_confirmation_of(:password) }
    end
  end
  describe "methods" do
    let(:user){FactoryBot.create :user}

    context "recent_orders" do
      let!(:order_1){FactoryBot.create :order, user_id: user.id}
      let!(:order_2){FactoryBot.create :order, user_id: user.id}

      it "return orders of user has sort DESC" do
        expect(user.all_orders).to eq([order_2, order_1])
      end
    end
  end
end
