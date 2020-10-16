require 'rails_helper'

module Pig
  RSpec.describe Admin::CommentsController, type: :routing do
    routes { Pig::Engine.routes }

    describe 'routing' do
      it 'routes to #create' do
        cp = FactoryBot.create(:content_package)
        expect( post: "/admin/content_packages/#{cp.permalink.full_path}/comments" ).
          to route_to(controller: 'pig/admin/comments', action: 'create', content_package_id: cp.permalink.path)
      end

    end
  end
end
