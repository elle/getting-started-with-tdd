require "rails_helper"

feature "Creates new user" do
  scenario "successfully" do
    visit root_path

    fill_in "First name", with: "Andrew"
    fill_in "user[last_name]", with: "Smith"
    fill_in "user_email", with: "andrew@example.com"
    click_on "Create"

    expect(page).to have_text "Horay!"
  end
end
