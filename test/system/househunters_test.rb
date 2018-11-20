require "application_system_test_case"

class HousehuntersTest < ApplicationSystemTestCase
  setup do
    @househunter = househunters(:one)
  end

  test "visiting the index" do
    visit househunters_url
    assert_selector "h1", text: "Househunters"
  end

  test "creating a Househunter" do
    visit househunters_url
    click_on "New Househunter"

    fill_in "Contact Method", with: @househunter.contact_method
    fill_in "First Name", with: @househunter.first_name
    fill_in "Last Name", with: @househunter.last_name
    fill_in "Phone", with: @househunter.phone
    fill_in "User", with: @househunter.user_id
    click_on "Create Househunter"

    assert_text "Househunter was successfully created"
    click_on "Back"
  end

  test "updating a Househunter" do
    visit househunters_url
    click_on "Edit", match: :first

    fill_in "Contact Method", with: @househunter.contact_method
    fill_in "First Name", with: @househunter.first_name
    fill_in "Last Name", with: @househunter.last_name
    fill_in "Phone", with: @househunter.phone
    fill_in "User", with: @househunter.user_id
    click_on "Update Househunter"

    assert_text "Househunter was successfully updated"
    click_on "Back"
  end

  test "destroying a Househunter" do
    visit househunters_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Househunter was successfully destroyed"
  end
end
