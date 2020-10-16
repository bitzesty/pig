Given(/^the content package has an old permalink alias$/) do
 @permalink_alias = FactoryBot.create(:permalink,
                                       resource: @content_package,
                                       created_at: 1.week.ago)
end

Given(/^the content package has a new permalink alias$/) do
 @permalink_alias = FactoryBot.create(:permalink,
                                       resource: @content_package)
end

When(/^I delete the permalink alias$/) do
  click_link 'Meta'
  page.find(:xpath, "//a[@href='#{pig.admin_permalink_path(@permalink_alias)}']").click
end

Then(/^the permalink alias should be removed$/) do
  expect(Pig::Permalink.all).to_not include(@permalink_alias)
end


Then(/^I should not be able to delete the permalink alias$/) do
  click_link 'Meta'
  expect{ page.find(:xpath, "//a[@href='#{pig.admin_permalink_path(@permalink_alias)}']") }.to raise_error(Capybara::ElementNotFound)
end
