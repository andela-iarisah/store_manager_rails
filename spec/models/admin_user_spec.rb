require 'rails_helper'

describe AdminUser, type: :model do
  context "super admin" do
    describe "valid admin user" do
      it "has a password" do
        super_admin_user = create(:super_admin_user)
        expect(super_admin_user.password).to eq("superpass")
      end
    end
  end

  context "regular admin" do
    describe "valid admin user" do
      it "has a password" do
        admin_user = create(:admin_user)
        expect(admin_user.password).to eq("password")
      end
    end
  end
end
