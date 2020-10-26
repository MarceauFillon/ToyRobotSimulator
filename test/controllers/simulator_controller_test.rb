require 'test_helper'

class SimulatorControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get simulator_index_url
    assert_response :success
  end

end
