require 'test_helper'

class RobotsControllerTestIndex < ActionDispatch::IntegrationTest
  test "should get index with create button" do
    get robots_url
    assert_response :success
    assert_select "h1", text:"Toy Robot Simulator"
    assert_select "input", value:"Create Robot"
    assert_select "i.fa-space-shuttle", false
  end

  test "should get index and return first robot" do
    robot = Robot.new(x:0, y:0, orientation:0, on_table:false)
    robot.save
    get robots_url
    assert_response :success
    assert_select "h1", text:"Toy Robot Simulator"
    assert_select "input", value:"Destroy Robot"
    assert_select "i.fa-space-shuttle", false
  end
end

class RobotsControllerTestShow < ActionDispatch::IntegrationTest
  test "should show attributes of robot" do
    robot = Robot.new(x:0, y:0, orientation:0, on_table:false)
    robot.save
    get robot_url(robot)
    assert_response :success
    assert_select "p", text:"X:0"
    assert_select "p", text:"Y:0"
    assert_select "p", text:"Orientation:0"
    assert_select "p", text:"On Table?:false"
  end
end

class RobotsControllerTestCreate < ActionDispatch::IntegrationTest
  test "should create a robot" do
    assert_difference('Robot.count') do
      post robots_path(format: :js)
    end
    assert_response :success
    assert_equal "text/javascript", @response.media_type
  end

  test "should not create a robot" do
    robot = Robot.new(x:0, y:0, orientation:0, on_table:false)
    robot.save
    assert_no_difference('Robot.count') do
      post robots_path(format: :js)
    end
    assert_response :success
    assert_equal "text/javascript", @response.media_type
    assert_equal "alert('The robot is already created!')", @response.body
  end
end

class RobotsControllerTestPlace < ActionDispatch::IntegrationTest
  test "place cannot find robot without id" do
    robot = Robot.new(x:0, y:0, orientation:0, on_table:false)
    assert_raise(ActiveRecord::RecordNotFound){post robots_place_path(robot)}
  end

  test "place cannot find robot " do
    robot = Robot.new(x:0, y:0, orientation:0, on_table:false)
    robot.save
    assert_raise(ActiveRecord::RecordNotFound){post robots_place_path(params: {id:robot.id + 1})}
  end

  test "place with invalid coordinates" do
    robot = Robot.new(x:0, y:0, orientation:0, on_table:false)
    robot.save
    assert_raise(ActionController::UnknownFormat){post robots_place_path(format: :js), params:{id: robot.id, robot: {x:-2, y:6, orientation:0}}, xhr: true}
  end

  test "place with invalid orientation" do
    robot = Robot.new(x:0, y:0, orientation:0, on_table:false)
    robot.save
    assert_raise(ActionController::UnknownFormat){post robots_place_path(format: :js), params:{id: robot.id, robot: {x:4, y:4, orientation:230}}, xhr: true}
  end

  test "place with valid parameters" do
    robot = Robot.new(x:0, y:0, orientation:0, on_table:false)
    robot.save
    post robots_place_path(format: :js), params:{id: robot.id, robot: {x:4, y:4, orientation:270}}, xhr: true
    assert_response :success
    assert_equal "text/javascript", @response.media_type
  end
end

class RobotsControllerTestMove < ActionDispatch::IntegrationTest
  test "move cannot find robot without id" do
    robot = Robot.new(x:0, y:0, orientation:0, on_table:false)
    assert_raise(ActiveRecord::RecordNotFound){post robots_move_path(robot)}
  end

  test "move cannot find robot" do
    robot = Robot.new(x:0, y:0, orientation:0, on_table:false)
    robot.save

    assert_raise(ActiveRecord::RecordNotFound){post robots_move_path(params: {id:robot.id + 1})}
  end

  test "impossible move" do
    robot = Robot.new(x:4, y:0, orientation:270, on_table:true)
    robot.save

    post robots_move_path(params: {id:robot.id}, format: :js)

    assert_response :success
    assert_equal "text/javascript", @response.media_type
    assert_match "blinkError()", @response.body
    assert_equal 4, Robot.first.x
    assert_equal 0, Robot.first.y
  end

  test "move object not on table" do
    robot = Robot.new(x:4, y:0, orientation:270, on_table:false)
    robot.save

    post robots_move_path(params: {id:robot.id}, format: :js)

    assert_response :success
    assert_equal "text/javascript", @response.media_type
    assert_match "blinkError()", @response.body
    assert_equal 4, Robot.first.x
    assert_equal 0, Robot.first.y
  end

  test "possible move" do
    robot = Robot.new(x:4, y:0, orientation:90, on_table:true)
    robot.save

    post robots_move_path(params: {id:robot.id}, format: :js)

    assert_response :success
    assert_equal "text/javascript", @response.media_type
    assert_match "fa-space-shuttle", @response.body
    assert_equal 3, Robot.first.x
    assert_equal 0, Robot.first.y
  end
end

class RobotsControllerTestRotate < ActionDispatch::IntegrationTest
  test "rotate cannot find robot without id" do
    robot = Robot.new(x:0, y:0, orientation:0, on_table:false)
    assert_raise(ActiveRecord::RecordNotFound){post robots_rotate_path(robot)}
  end

  test "rotate cannot find robot" do
    robot = Robot.new(x:0, y:0, orientation:0, on_table:false)
    robot.save

    assert_raise(ActiveRecord::RecordNotFound){post robots_rotate_path(params: {id:robot.id + 1})}
  end

  test "rotate with invalid direction" do
    robot = Robot.new(x:4, y:0, orientation:270, on_table:true)
    robot.save

    post robots_rotate_path(params: {id:robot.id, direction:"east"}, format: :js)

    assert_response :success
    assert_equal "text/javascript", @response.media_type
    assert_match "blinkError()", @response.body
    assert_equal 270, Robot.first.orientation
  end

  test "rotate object not on table" do
    robot = Robot.new(x:4, y:0, orientation:270, on_table:false)
    robot.save

    post robots_rotate_path(params: {id:robot.id}, format: :js)

    assert_response :success
    assert_equal "text/javascript", @response.media_type
    assert_match "blinkError()", @response.body
    assert_equal 4, Robot.first.x
    assert_equal 0, Robot.first.y
  end

  test "rotate right" do
    robot = Robot.new(x:4, y:0, orientation:270, on_table:true)
    robot.save

    post robots_rotate_path(params: {id:robot.id, direction:"right"}, format: :js)

    assert_response :success
    assert_equal "text/javascript", @response.media_type
    assert_match "fa-space-shuttle", @response.body
    assert_equal 0, Robot.first.orientation
  end

  test "rotate left" do
    robot = Robot.new(x:4, y:0, orientation:270, on_table:true)
    robot.save

    post robots_rotate_path(params: {id:robot.id, direction:"left"}, format: :js)

    assert_response :success
    assert_equal "text/javascript", @response.media_type
    assert_match "fa-space-shuttle", @response.body
    assert_equal 180, Robot.first.orientation
  end

end

class RobotsControllerTestReport < ActionDispatch::IntegrationTest
  test "report cannot find robot without id" do
    robot = Robot.new(x:0, y:0, orientation:0, on_table:false)
    post robots_report_path(format: :js)
    assert_response :success
    assert_equal "text/javascript", @response.media_type
    assert_match "No robot", @response.body
  end

  test "report cannot find robot" do
    robot = Robot.new(x:0, y:0, orientation:0, on_table:false)
    robot.save

    assert_raise(ActiveRecord::RecordNotFound){post robots_report_path(params: {id:robot.id + 1})}
  end

  test "report robot not on table" do
    robot = Robot.new(x:0, y:0, orientation:0, on_table:false)
    robot.save

    post robots_report_path(params: {id: robot.id}, format: :js)
    assert_response :success
    assert_equal "text/javascript", @response.media_type
    assert_match "Robot not on table", @response.body
  end

  test "report robot position" do
    robot = Robot.new(x:4, y:3, orientation:0, on_table:true)
    robot.save

    post robots_report_path(params: {id: robot.id}, format: :js)
    assert_response :success
    assert_equal "text/javascript", @response.media_type
    assert_match "4 3 East", @response.body
  end

end

class RobotsControllerTestDestroy < ActionDispatch::IntegrationTest
  test "destroy cannot find robot without id" do
    robot = Robot.new(x:0, y:0, orientation:0, on_table:false)
    assert_raise(ActiveRecord::RecordNotFound){delete robots_destroy_path(robot)}
  end

  test "destroy cannot find robot" do
    robot = Robot.new(x: 0, y: 0, orientation: 0, on_table: false)
    robot.save
    assert_raise(ActiveRecord::RecordNotFound){delete robots_destroy_path(params: {id: robot.id + 1})}
  end

  test "destroy robot" do
    robot = Robot.new(x:0, y:0, orientation:0, on_table:false)
    robot.save
    assert_difference("Robot.count", -1) do
      delete robots_destroy_path(params: {id: robot.id}, format: :js)
    end
    assert_equal "text/javascript", @response.media_type
  end
end