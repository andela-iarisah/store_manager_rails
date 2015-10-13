require 'rails_helper'

describe Item do
  context "associations" do
    it {is_expected.to have_many :admin_users}
    it {is_expected.to have_many :admin_user_items}
  end

  context "valid items" do
    describe "has a category" do
      it do
        item = create(:item)
        expect(item.category).to eq("Music")
      end
    end
  end

  context "invalid items" do
    describe "minimum quantity larger than quantity" do
      it "raises an error" do
        expect{
          create(:invalid_item, name: 'Doll')
        }.to raise_error("Validation failed: Min qty should be less than quantity added")
      end
    end

    describe  "invalid characters" do
      it "raises an error" do
        expect{
          create(:invalid_item_value)
        }.to raise_error("Validation failed: Quantity is not a number")
      end
    end

    describe "duplicate item" do
      it "raises an error" do
        create(:item)
        expect{
          create(:item, name: 'cassette')
        }.to raise_error("Validation failed: Name This item already exists")
      end
    end
  end
end
