require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Assuming you have fixtures or factories for attendees
    @attendee = attendees(:one) # This uses fixtures. Adjust as needed.
  end

  test "should get new" do
    get new_session_url
    assert_response :success
  end

  test "should log in user with valid credentials" do
    post sessions_url, params: { email_address: 'admin123@gmail.com', password: 'admin123' } # Ensure the password matches your fixture/factory
    assert_redirected_to root_url
    assert_equal @attendee.id, session[:user_id], "User ID should be set in session"
  end

  test "should not log in user with invalid credentials" do
    post sessions_url, params: { email_address: 'qwerty@gm.com', password: 'admin123' }
    assert_response :success # The action re-renders `new` on failure
    assert_nil session[:user_id], "User ID should not be set in session"
    assert_select ".alert", "Email or password is invalid"
  end

  test "should log out user" do
    delete session_url(@attendee)
    assert_redirected_to root_url
    assert_nil session[:user_id], "User ID should be cleared from session"
  end

end
