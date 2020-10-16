require 'rails_helper'

module Pig
  RSpec.describe ContentPackage do

    let(:content_package) do
      FactoryBot.create(:content_package,
                          status: 'draft',
                          name: 'Test name')
    end

    describe 'creating new versions' do
      context 'when changing status from published' do
        it 'it creates a new version' do
          content_package.update_attributes status: 'published'
          expect(content_package.versions.count).to eq(0)

          content_package.update_attributes status: 'draft'
          expect(content_package.versions.count).to eq(1)
        end
      end

      context 'when changing status to pending' do
        it 'it does not create a new version' do
          content_package.update_attributes status: 'pending'
          expect(content_package.versions.count).to eq(0)
        end
      end

      context 'when changing status to draft' do
        it 'it does not create a new version' do
          content_package.update_attributes status: 'draft'
          expect(content_package.versions.count).to eq(0)
        end
      end
    end

    describe 'getting live version' do
      context 'when there is no published version' do
        it 'should return the content package' do
          expect(content_package.live_version).to equal(content_package)
        end
      end

      context 'when there is a published version' do
        before do
          content_package.update_attributes status: 'published', name: 'Published name'
        end

        it 'should return the published version' do
          content_package.update_attributes name: 'Changed name', status: 'draft'
          expect(content_package.live_version.name).to eq('Published name')
        end

        context 'and there are previous versions' do
          it 'should return the published version' do
            content_package.update_attributes name: 'New name'
            expect(content_package.live_version.name).to eq('New name')
          end
        end
      end
    end

  end
end
