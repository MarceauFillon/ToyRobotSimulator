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
            format.js {render js: alert("The robot is already created!")}
        end
    end

    def place
        @robot = Robot.find(params[:id])

        if !@robot.on_table?
            @robot.on_table = true
        end

        @old_position = [@robot.x, @robot.y]

        respond_to do |format|
            if @robot.update(robot_parameters)
                format.js
            end
        end 
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
end
