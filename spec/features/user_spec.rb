require 'rails_helper'

describe "User Actions", type: :feature do
  let(:user) { create(:user) }


  scenario "user can not create new items" do
    given_i_log_in
    then_i_should_not_be_able_to_create_an_item
  end

  scenario "user can not view admin platform" do
    given_i_log_in
    visit admin_items_path
    then_i_should_hit_an_error
  end

  scenario "user can edit some details" do
    user_first_update
  end

  scenario "nick changes to email if not available" do
    user_first_update
    click_on "Edit Profile"
    fill_in "Nickname", with: ""
    fill_in "Mobile number", with: "12341231234"
    click_on 'Save'
    expect(page).to have_content("Hi, #{user.full_name}")
    expect(page).not_to have_content("Phone number")
    expect(page).not_to have_content("Hi, Hakuna Matata")
  end

  def given_i_log_in
    visit root_path
    login user
  end

  def then_i_should_not_be_able_to_create_an_item
    expect(page).not_to have_content('Create a new Item')
    expect(page).to have_content('Log Out')
  end

  def user_first_update
    given_i_log_in
    and_edit_my_profile
    then_i_should_be_updated
  end

  def then_i_should_hit_an_error
    expect(page).to have_content('You are not authorized to view this page')
  end

  def and_edit_my_profile
    click_on 'Jay Jay'
    click_on 'Edit Profile'
    fill_in 'Nickname', with: 'Hakuna Matata'
    fill_in "Mobile number", with: "12341231234"
    fill_in "Phone number", with: "12121212122"
    click_on 'Save'
  end

  def then_i_should_be_updated
    expect(page).to have_content('Successfully updated profile')
    expect(page).to have_content('Hi, Hakuna Matata')
    expect(page).not_to have_content("Hi, #{user.full_name}")
    expect(page).to have_content("Phone Number")
    expect(page).to have_content("12121212122")
  end
end
