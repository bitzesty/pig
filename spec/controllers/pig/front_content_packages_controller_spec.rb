require 'rails_helper'
require 'benchmark'

module Pig
  RSpec.describe Front::ContentPackagesController, type: :controller do
    routes { Pig::Engine.routes }

    describe 'GET #show' do
      it 'assigns the requested content_package as @content_package' do
        content_package = FactoryBot.create(:content_package)
        time = Benchmark.realtime do
          2.times do
            get :show, { path: content_package.to_param }, {}
          end
        end
        puts "Time elapsed #{time*1000} milliseconds"
        expect(assigns(:content_package)).to eq(content_package)
      end
    end

  end
end
