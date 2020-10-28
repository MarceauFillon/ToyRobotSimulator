class RobotsController < ApplicationController
    # Action returning the application page
    # Returns the first robot in the list if it exists
    # The maximum number of robot is one.
    def index
        if Robot.all().any?
            @robot = Robot.first # Return the first and only robot
        end
    end

    # Action useful to debug the application
    # Returns a robot with a specific id
    # The show view displays the robot attributes
    def show
        @robot = Robot.find(params[:id])
    end

    # Action to create a robot
    # No input is taken from the user and the robot is initialised at 0,0 and is not on the table
    # If successful, a script is called to enable the place commands and convert the creation button into a destruction button.
    # If the user interface failed and the creation button is not disabled, the user can still not create a robot.
    def create
        if !Robot.all().any?
            @robot = Robot.new({x:0, y:0, orientation:0, on_table:false})
            @robot.save
            respond_to do |format|
                format.js {render "make"} # Call the 'make' script updating the creation/deletion button.
            end
        else # If the database already contains a robot, alert the user that no more robot can be created.
            render js: "alert('The robot is already created!')"
        end
    end

    # Action to place the robot on the table
    # This action can only be perform with the attributes x, y and orientation in the POST request
    # If successful, it calls the 'place' script, updating the robot position in the UI and enabling the movement buttons.
    def place
        @robot = Robot.find(params[:id]) # Find the robot with the specified id

        if !@robot.on_table # Place the robot on the table
            @robot.on_table = true
        end

        @old_position = [@robot.x, @robot.y] # Save the old position to delete the robot from its old position in the UI
        
        respond_to do |format|
            if @robot.update(robot_parameters) # Check that the parameters x, y and orientation were given (and only those)
                format.js # Call the place script to update the UI
            end
        end 
    end

    # Action to move the robot on the table
    # The robot can move one unit in the direction it's oriented but cannot go out of the table.
    # If the movement is invalid (i.e going out of the table), the 'error' script is called to warn the user.
    # If successful, it calls the 'place' script, updating the robot position in the UI.
    def move
        @robot = Robot.find(params[:id]) # Find the robot with the specified id
        @old_position = [@robot.x, @robot.y] # Save old position to update the table in the UI

        if !@robot.move # If the move is invalid, this condition is false and the error script is called
            return_error
            return
        end
        
        @robot.save()
        return_place # Calls the 'place' script
    end

    # Action to rotate the robot on the table
    # The robot can rotate 90 degrees at a time either on its right or on its left.
    # If the direction is not left or right, the error script is called to warn the user.
    # If successful, it calls the 'place' script, updating the robot orientation in the UI.
    def rotate
        @robot = Robot.find(params[:id]) # Find the robot with the specified id
        @old_position = [@robot.x, @robot.y] # Save old position to update the table in the UI

        direction = params[:direction] # Get the direction parameter from the POST request

        if !@robot.rotate(direction) # If the direction was not valid, call the error script
            return_error
            return
        end
        
        @robot.save()
        return_place # Call the place script to update the UI

    end

    # Action to report the robot state in the scrolling log
    # The log will output the position of the robot on the table and its orientation
    # Error messages will be output if the robot does not exist or is not on the table
    # For each request, this action will call the 'report' script to update the scrolling log. 
    def report
        @report_result = "" # Initiate output
        id = params[:id]
        if !id # If no id is passed, no robot has been created.
            @report_result = "No robot"
            return_report # Call 'report' script to update the UI
            return 
        end

        robot = Robot.find(id) # Get the robot with the specified ID

        if !robot.on_table # Robot not placed on the table
            @report_result = "Robot not on table"
            return_report # Call 'report' script to update the UI
            return
        end

        @report_result = "%d %d %s" % [robot.x, robot.y, robot.get_orientation_string] # Format the output with the position and orientation

        return_report # Call 'report' script to update the UI
        
    end

    # Action to destroy a robot
    # If successful, a script is called to disable the place and movement commands and convert the destruction button into a creation button.
    def destroy
        @robot = Robot.find(params[:id])
        @old_position = [@robot.x, @robot.y] # Save the old position to delete robot from UI

        @robot.destroy
        @robot = nil # Setting the robot to let the views know that this robot is not in the table anymore

        respond_to do |format|
            format.js {render "make"} # Update the robot commands in the UI
        end
    end

    private
        # Private function to control that x, y and orientation are passed in a request (and only those)
        def robot_parameters
            params.require(:robot).permit(:x, :y, :orientation)
        end

        # Calls the 'error' script
        def return_error
            respond_to do |format|
                format.js {render "error"}
            end
        end

        # Calls the 'report' script
        def return_report
            respond_to do |format|
                format.js {render "report"}
            end 
        end

        # Calls the 'place' script
        def return_place
            respond_to do |format|
                format.js {render "place"}
            end 
        end
end
