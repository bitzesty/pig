require 'rails_helper'

module Pig
  RSpec.describe Admin::CommentsController, type: :controller do
    routes { Pig::Engine.routes }

    let(:content_package) do
      FactoryBot.create(:content_package)
    end

    let(:valid_attributes) do
      ControllerMacros.attributes_with_foreign_keys(:comment)
    end

    let(:valid_session) { {} }

    context "not signed in" do
      it "should redirect create to sign in" do
        post :create, { comments: valid_attributes, content_package_id: content_package.id }, valid_session
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "signed in" do
      login_admin
      describe "GET #create" do
        it "returns http success" do
          post :create, { comments: valid_attributes, content_package_id: content_package.id }, valid_session
          expect(response).to have_http_status(:success)
          expect(Pig::Comment.count).to eq(1)
        end
      end
    end

  end
end
