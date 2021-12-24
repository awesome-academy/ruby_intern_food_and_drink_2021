require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "Associations" do
    it { should belong_to(:user) }
    it { should have_many(:carts).dependent(:destroy) }
    it { should have_many(:foods).through(:carts) }
  end

  describe "Delegates" do
    it { should delegate_method(:name).to(:user).with_prefix(true) }
    it { should delegate_method(:email).to(:user).with_prefix(true) }
  end

  describe "Scope" do
    let!(:order_1){FactoryBot.create :order}
    let!(:order_2){FactoryBot.create :order}

    it "return orders has sort DESC" do
      expect Order.recent_orders.should eq [order_2, order_1]
    end
  end

  describe "enums" do
    it "define status as an enum" do
      should define_enum_for(:status)
    end
    it "define role as an enum" do
      should define_enum_for(:role)
    end
  end

  describe "Validations" do
    context "with field phone" do
      it { should validate_presence_of(:phone) }
      it { should validate_length_of(:phone).is_at_least(Settings.len_min) }
    end
    context "with field address" do
      it { should validate_presence_of(:address) }
      it { should validate_length_of(:address).is_at_least(Settings.len_min) }
    end
    context "with field total" do
      it { should validate_presence_of(:total) }

      it { should validate_numericality_of(:total) }

      it { should allow_value(0).for(:total) }

      it { should_not allow_value(-1).for(:total) }
    end
  end
end
