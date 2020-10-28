require 'test_helper'

class RobotTestSave < ActiveSupport::TestCase
  test "should not save without on_table" do
    robot = Robot.new(x:0, y:0, orientation:0)
    assert_not robot.save, "Saved a robot without on_table"
  end

  test "should not save without x" do
    robot = Robot.new(y:0, orientation:0, on_table:false)
    assert_not robot.save, "Saved a robot without x coordinate"
  end

  test "should not save with x<0" do
    robot = Robot.new(x:-1, y:0, orientation:0, on_table:false)
    assert_not robot.save, "Saved a robot with x negative"
  end

  test "should not save with x>4" do
    robot = Robot.new(x:5, y:0, orientation:0, on_table:false)
    assert_not robot.save, "Saved a robot with x greater than 4"
  end

  test "should not save without y" do
    robot = Robot.new(x:0, orientation:0, on_table:false)
    assert_not robot.save, "Saved a robot without y coordinate"
  end

  test "should not save with y<0" do
    robot = Robot.new(x:0, y:-1, orientation:0, on_table:false)
    assert_not robot.save, "Saved a robot with y negative"
  end

  test "should not save with y>4" do
    robot = Robot.new(x:0, y:5, orientation:0, on_table:false)
    assert_not robot.save, "Saved a robot with y greater than 4"
  end

  test "should not save without orientation" do
    robot = Robot.new(x:0, y:0, on_table:false)
    assert_not robot.save, "Saved a robot without orientation"
  end

  test "should not save with invalid orientation" do
    robot = Robot.new(x:0, y:0, orientation:450, on_table:false)
    assert_not robot.save, "Saved a robot with invalid orientation"
  end

  test "should not save two robots" do
    robot = Robot.new(x:0, y:0, orientation:0, on_table:false)
    assert robot.save, "Saving a robot failed"
    robot2 = Robot.new(x:0, y:0, orientation:0, on_table:false)
    assert_not robot2.save, "Saved a robot while a robot already existed"
  end

  test "should save" do 
    robot = Robot.new(x:0, y:0, orientation:0, on_table:false)
    assert robot.save, "Saving a robot failed"
  end

  test "should save second robot after destroy" do
    robot1 = Robot.new(x:0, y:0, orientation:0, on_table:false)
    robot1.save
    robot2 = Robot.new(x:0, y:0, orientation:0, on_table:false)
    robot1.destroy
    assert robot2.save, "Did not save a robot with an empty robot list"
  end
end

class RobotTestUpdate < ActiveSupport::TestCase
  test "should not update if robot not on_table" do
    robot = Robot.new(x:0, y:0, orientation:0, on_table:false)
    robot.save
    assert_not robot.update({x:1, y:1}), "Robot updated while not on table"
  end
end

class RobotTestMove < ActiveSupport::TestCase
  test "should not move west and fall from table" do
    robot = Robot.new(x:0, y:0, orientation:180, on_table:true)
    assert_not robot.move, "Robot fell off the table"
  end

  test "should not move south and fall from table" do
    robot = Robot.new(x:0, y:0, orientation:90, on_table:true)
    assert_not robot.move, "Robot fell off the table"
  end

  test "should not move north and fall from table" do
    robot = Robot.new(x:4, y:4, orientation:270, on_table:true)
    assert_not robot.move, "Robot fell off the table"
  end

  test "should not move east and fall from table" do
    robot = Robot.new(x:4, y:4, orientation:0, on_table:true)
    assert_not robot.move, "Robot fell off the table"
  end

  test "should only move east" do
    robot1 = Robot.new(x:0, y:0, orientation:0, on_table:true)
    robot2 = Robot.new(x:1, y:0, orientation:0, on_table:true)
    robot1.move
    assert_equal robot2.attributes, robot1.attributes, "Robot did not move only east"
  end

  test "should only move north" do
    robot1 = Robot.new(x:0, y:0, orientation:270, on_table:true)
    robot2 = Robot.new(x:0, y:1, orientation:270, on_table:true)
    robot1.move
    assert_equal robot2.attributes, robot1.attributes, "Robot did not move only north"
  end

  test "should only move west" do
    robot1 = Robot.new(x:1, y:0, orientation:180, on_table:true)
    robot2 = Robot.new(x:0, y:0, orientation:180, on_table:true)
    robot1.move
    assert_equal robot2.attributes, robot1.attributes, "Robot did not move only west"
  end

  test "should only move south" do
    robot1 = Robot.new(x:0, y:1, orientation:90, on_table:true)
    robot2 = Robot.new(x:0, y:0, orientation:90, on_table:true)
    robot1.move
    assert_equal robot2.attributes, robot1.attributes, "Robot did not move only south"
  end
end

class RobotTestRotate < ActiveSupport::TestCase
  test "should not rotate" do
    robot = Robot.new(x:0, y:0, orientation:0, on_table:true)
    assert_not robot.rotate("east"), "Robot rotated with invalid direction"
  end

  test "should face north turning left" do
    robot1 = Robot.new(x:0, y:0, orientation:0, on_table:true)
    robot2 = Robot.new(x:0, y:0, orientation:270, on_table:true)
    robot1.rotate("left")
    assert_equal robot2.attributes, robot1.attributes, "Robot did not rotate left"
  end

  test "should face north turning right" do
    robot1 = Robot.new(x:0, y:0, orientation:180, on_table:true)
    robot2 = Robot.new(x:0, y:0, orientation:270, on_table:true)
    robot1.rotate("right")
    assert_equal robot2.attributes, robot1.attributes, "Robot did not rotate right"
  end

  test "should face east turning right" do
    robot1 = Robot.new(x:0, y:0, orientation:270, on_table:true)
    robot2 = Robot.new(x:0, y:0, orientation:0, on_table:true)
    robot1.rotate("right")
    assert_equal robot2.attributes, robot1.attributes, "Robot did not rotate right"
  end

  test "should face east turning left" do
    robot1 = Robot.new(x:0, y:0, orientation:90, on_table:true)
    robot2 = Robot.new(x:0, y:0, orientation:0, on_table:true)
    robot1.rotate("left")
    assert_equal robot2.attributes, robot1.attributes, "Robot did not rotate left"
  end

  test "should face south turning right" do
    robot1 = Robot.new(x:0, y:0, orientation:0, on_table:true)
    robot2 = Robot.new(x:0, y:0, orientation:90, on_table:true)
    robot1.rotate("right")
    assert_equal robot2.attributes, robot1.attributes, "Robot did not rotate right"
  end

  test "should face south turning left" do
    robot1 = Robot.new(x:0, y:0, orientation:180, on_table:true)
    robot2 = Robot.new(x:0, y:0, orientation:90, on_table:true)
    robot1.rotate("left")
    assert_equal robot2.attributes, robot1.attributes, "Robot did not rotate left"
  end

  test "should face west turning right" do
    robot1 = Robot.new(x:0, y:0, orientation:90, on_table:true)
    robot2 = Robot.new(x:0, y:0, orientation:180, on_table:true)
    robot1.rotate("right")
    assert_equal robot2.attributes, robot1.attributes, "Robot did not rotate right"
  end

  test "should face west turning left" do
    robot1 = Robot.new(x:0, y:0, orientation:270, on_table:true)
    robot2 = Robot.new(x:0, y:0, orientation:180, on_table:true)
    robot1.rotate("left")
    assert_equal robot2.attributes, robot1.attributes, "Robot did not rotate left"
  end
end

class RobotTestGetOrientationString < ActiveSupport::TestCase
  test "should be invalid" do
    robot = Robot.new(x:0, y:0, orientation:450, on_table:false)
    assert_equal "Invalid", robot.get_orientation_string, "Orientation is not invalid"
  end

  test "should be North" do
    robot = Robot.new(x:0, y:0, orientation:270, on_table:false)
    assert_equal "North", robot.get_orientation_string, "Orientation is not North"
  end

  test "should be South" do
    robot = Robot.new(x:0, y:0, orientation:90, on_table:false)
    assert_equal "South", robot.get_orientation_string, "Orientation is not South"
  end

  test "should be East" do
    robot = Robot.new(x:0, y:0, orientation:0, on_table:false)
    assert_equal "East", robot.get_orientation_string, "Orientation is not East"
  end

  test "should be West" do
    robot = Robot.new(x:0, y:0, orientation:180, on_table:false)
    assert_equal "West", robot.get_orientation_string, "Orientation is not West"
  end
end
