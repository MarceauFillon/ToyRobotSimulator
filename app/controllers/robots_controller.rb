class RobotsController < ApplicationController
    def index
        if Robot.all().any?
            @robot = Robot.first
        end
    end

    def show
        @robot = Robot.find(params[:id])
    end

    def create
        if !Robot.all().any?
            @robot = Robot.new({x:0, y:0, orientation:0, on_table:false})
            @robot.save
            respond_to do |format|
                format.js {render "make"}
            end
        else
            render js: "alert('The robot is already created!')"
        end
    end

    def place
        @robot = Robot.find(params[:id])

        if !@robot.on_table
            @robot.on_table = true
        end

        @old_position = [@robot.x, @robot.y]
        
        respond_to do |format|
            if @robot.update(robot_parameters)
                format.js
            end
        end 
    end

    def move
        @robot = Robot.find(params[:id])
        @old_position = [@robot.x, @robot.y]

        if !@robot.move
            return_error
            return
        end
        
        @robot.save()
        return_place
    end

    def rotate
        @robot = Robot.find(params[:id])
        @old_position = [@robot.x, @robot.y]

        direction = params[:direction]

        if !@robot.rotate(direction)
            return_error
            return
        end
        
        @robot.save()
        return_place

    end

    def report
        @report_result = ""
        id = params[:id]
        if !id
            @report_result = "No robot"
            return_report
            return 
        end

        robot = Robot.find(id)

        if !robot.on_table
            @report_result = "Robot not on table"
            return_report
            return
        end

        @report_result = "%d %d %s" % [robot.x, robot.y, robot.get_orientation_string]

        return_report
        
    end

    def destroy
        @robot = Robot.find(params[:id])
        @old_position = [@robot.x, @robot.y]

        @robot.destroy
        @robot = nil

        respond_to do |format|
            format.js {render "make"}
        end
    end

    private
        def robot_parameters
            params.require(:robot).permit(:x, :y, :orientation)
        end

        def return_error
            respond_to do |format|
                format.js {render "error"}
            end
        end

        def return_report
            respond_to do |format|
                format.js {render "report"}
            end 
        end

        def return_place
            respond_to do |format|
                format.js {render "place"}
            end 
        end
end
