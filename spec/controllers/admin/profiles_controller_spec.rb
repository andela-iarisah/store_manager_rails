require 'rails_helper'

describe Admin::ProfilesController do

  let(:admin_user) { create(:admin_user) }

  render_views

  before do
    sign_in admin_user
  end

  describe "#show" do
    it do
      get :show
      expect(response).to have_http_status(200)
    end
  end

  describe "#edit" do
    it do
      get :edit
      expect(response).to have_http_status(200)
    end
  end
end
