require 'test_helper'

class HousehuntersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @househunter = househunters(:one)
  end

  test "should get index" do
    get househunters_url
    assert_response :success
  end

  test "should get new" do
    get new_househunter_url
    assert_response :success
  end

  test "should create househunter" do
    assert_difference('Househunter.count') do
      post househunters_url, params: { househunter: { contact_method: @househunter.contact_method, first_name: @househunter.first_name, last_name: @househunter.last_name, phone: @househunter.phone, user_id: @househunter.user_id } }
    end

    assert_redirected_to househunter_url(Househunter.last)
  end

  test "should show househunter" do
    get househunter_url(@househunter)
    assert_response :success
  end

  test "should get edit" do
    get edit_househunter_url(@househunter)
    assert_response :success
  end

  test "should update househunter" do
    patch househunter_url(@househunter), params: { househunter: { contact_method: @househunter.contact_method, first_name: @househunter.first_name, last_name: @househunter.last_name, phone: @househunter.phone, user_id: @househunter.user_id } }
    assert_redirected_to househunter_url(@househunter)
  end

  test "should destroy househunter" do
    assert_difference('Househunter.count', -1) do
      delete househunter_url(@househunter)
    end

    assert_redirected_to househunters_url
  end
end
