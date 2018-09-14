require 'test_helper'

class FaceControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get face_index_url
    assert_response :success
  end

end
