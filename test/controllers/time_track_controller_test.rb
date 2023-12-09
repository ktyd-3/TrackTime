require "test_helper"

class TimeTrackControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get time_track_new_url
    assert_response :success
  end

  test "should get create" do
    get time_track_create_url
    assert_response :success
  end
end
