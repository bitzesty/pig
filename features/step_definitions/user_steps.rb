Given /^I am logged in as an (.*)$/ do |role|
  user = FactoryBot.create(:user, role.to_sym)
  stub_user(user)
end

Given /^I am logged in as any user$/ do
  user = FactoryBot.create(:user, :author)
  stub_user(user)
end

def stub_user(user)
  allow_any_instance_of(Pig::Admin::ApplicationController)
    .to receive(:current_user).and_return(user)
  allow_any_instance_of(Pig::Front::ApplicationController)
    .to receive(:current_user).and_return(user)
  @current_user = user
end

When(/^I go to the dashboard$/) do
  visit pig.admin_content_path
end

Given(/^there (?:are|is) (\d+)( unconfirmed)? user(?:s)?$/) do |n, unconfirmed|
  if n.to_i.zero?
    Pig::User.where('id != ?', @current_user.id).destroy_all
  end
  @users = [].tap do |arr|
    n.to_i.times do
      if unconfirmed
        arr << FactoryBot.create(:user, :unconfirmed, role: 'author')
      else
        arr << FactoryBot.create(:user, role: 'author')
      end
    end
  end
  @user = @users.first
end

When(/^I fill in the new cms user form and submit$/) do
  visit pig.new_admin_manage_user_path
  @user = FactoryBot.build(:user, role: 'author')
  fill_in "user_first_name", :with => @user.first_name
  fill_in "user_last_name", :with => @user.last_name
  fill_in "user_email", :with => @user.email
  select(@user.role.capitalize, :from => 'user_role')
  click_button('Save')
  @user = Pig::User.last
end

Then(/^the user is (created|updated)( but not confirmed)?$/) do |action, confirmed|
  visit pig.admin_manage_user_path(@user)
  expect(page).to have_content(@user.first_name)
  expect(page).to have_content(@user.last_name)
  if action == 'updated'
    expect(page).to have_content("Edited")
  end
  if confirmed
    expect(@user.confirmed?).to be_falsey
  end

  expect(page).to have_content(@user.role.try(:capitalize))
end

When(/^I fill in the edit cms user form and submit$/) do
  visit pig.edit_admin_manage_user_path(@user)
  fill_in "user_last_name", :with => "Edited"
  select(@user.role.capitalize, :from => 'user_role')
  click_button('Save')
  @user = Pig::User.find(@user.id)
end

When(/^I visit the cms user index$/) do
  visit pig.admin_manage_users_path
  expect(page).to have_content("ADD NEW USER")
end

Then(/^I see the cms users$/) do
  page.has_table? "users-table"
  user_rows = page.all('.user-row')
  expect(user_rows.count).to be > 1
end

When(/^I set the user as inactive$/) do
  btn = page.find(".user-row[data_user-id='#{@user.id}']").find('.user-actions').find('.set-active-btn')
  expect(btn).not_to be_nil
  btn.click
  sleep(2)
  page.find('form').find('input').click
  sleep(2)
end

Then(/^the user is inactive$/) do
  @user = Pig::User.find(@user.id)
  expect(@user.active).to be_falsey
end

Then(/^the user should( not)? be made an (.*)$/) do |not_equal, role|
  if not_equal
    expect(@user.reload.role).to_not eq(role)
  else
    expect(@user.reload.role).to eq(role)
  end
end

Given(/^the user is a (.*)$/) do |role|
  @user.update_attribute(:role, role)
end

When(/^I visit the manage account page$/) do
  visit pig.edit_admin_manage_user_path(@current_user)
end

When(/^I make a change to my account$/) do
  fill_in 'First name', with: 'Foo'
  click_button 'Save'
end

Then(/^my account is updated$/) do
  expect(@current_user.reload.first_name).to eq('Foo')
  visit pig.admin_manage_user_path(@current_user)
  expect(page).to have_text('Foo')
end

When(/^I change the role of the user to (.*)$/) do |role|
  visit pig.edit_admin_manage_user_path(@user)
  select(role.capitalize, from: 'user_role')
  click_button('Save')
end

When(/^I log out$/) do
  find('.cms-nav-user').click
  click_link 'Sign out'
end

Given(/^I have received an email to confirm my account$/) do
  @user = FactoryBot.create(:user)
  @user.send_confirmation_instructions
end

When(/^I visit the confirmation url$/) do
  open_email(@user.email)
  current_email.click_link 'Confirm my account'
end

When(/^I choose a password$/) do
  fill_in "user_password", with: 'password'
  fill_in "user_password_confirmation", with: 'password'
  click_button 'Confirm Account'
end

Then(/^(?:the|my) account should be confirmed$/) do
  @user.reload
  expect(@user.confirmed?).to be_truthy
end

When(/^I confirm the user$/) do
  visit pig.admin_manage_users_path
  click_link 'Confirm'
  wait_for_ajax
end
