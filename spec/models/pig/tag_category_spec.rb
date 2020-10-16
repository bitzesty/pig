require 'rails_helper'

module Pig
  RSpec.describe TagCategory do

    it { should have_many(:content_types) }
    it { should have_many(:resource_tag_categories) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:slug) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:slug) }

    it 'has a valid factory' do
      expect(FactoryBot.create(:tag_category)).to be_valid
    end

    describe 'slugs' do
      context 'on create' do
        it 'sets the slug' do
          tc = TagCategory.create(name: "a b c")
          expect(tc.slug).to eq("a-b-c")
        end
      end

      context 'on update' do
        it 'doesnt change the slug' do
          tc = TagCategory.create(name: "a b c")
          tc.update_attribute(:name, "x y z")
          expect(tc.slug).to eq("a-b-c")
        end
      end
    end

    describe '#tag_count_for' do
      subject { FactoryBot.create(:tag_category) }
      let(:tag) { FactoryBot.create(:tag) }

      before(:each) { subject.taxonomy_list << tag }

      context 'tag which is never used by the tag category' do
        it 'returns 0' do
          expect(subject.tag_count_for(tag)).to eq(0)
        end
      end

      context 'tag which is used once by this tag category' do
        it 'returns 1' do
          content_package = FactoryBot.create(:content_package)
          content_package.update(taxonomy_tags: { subject.slug => [tag.name] })
          expect(subject.tag_count_for(tag)).to eq(1)
        end
      end

      context 'tag which is used twice by this tag category' do
        it 'returns 10' do
          10.times do
            content_package = FactoryBot.create(:content_package)
            content_package.update(taxonomy_tags: { subject.slug => [tag.name] })
          end
          expect(subject.tag_count_for(tag)).to eq(10)
        end
      end
    end
  end
end
