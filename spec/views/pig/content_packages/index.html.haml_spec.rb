# require 'rails_helper'
#
# RSpec.describe 'pig/content_packages/index', type: :view do
#   let(:admin) { FactoryBot.create(:user, :admin) }
#   let(:content_package_1) { FactoryBot.create(:content_package, name: 'Foo') }
#   let(:content_package_2) { FactoryBot.create(:content_package, name: 'Bar') }
#
#   before(:each) do
#     assign(:content_packages, [
#       content_package_1,
#       content_package_2
#     ])
#     allow(view).to receive(:current_user).and_return(admin)
#     @ability = Pig::Ability.new(admin)
#     allow(controller).to receive(:current_ability).and_return(@ability)
#     render
#   end
#
#   it 'renders a list of content_packages' do
#     expect(rendered).to have_text('Foo')
#     expect(rendered).to have_text('Bar')
#   end
#
#   it 'links to the content package permalink' do
#     expect(rendered).to have_link('View', href: pig.content_package_path(content_package_1.permalink.full_path))
#   end
# end
