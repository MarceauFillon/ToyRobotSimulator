class Robot < ApplicationRecord
    before_update :check_presence_on_table
    before_save :check_uniqueness

    # Validation on coordinates to prevent coordinates outside of the table
    # Validation on the orientation to only authorize 4 angles (East being 0 and North being 270)
    validates :x, inclusion:{ :in => 0..4} 
    validates :y, inclusion:{ :in => 0..4}
    validates :orientation, inclusion:{ :in => (0..270).step(90)}
    validates :on_table, inclusion:{ :in => [true, false]}

    # Function to move the robot one unit in the direction of its orientation
    def move
        # Robot cannot move if not placed on the table.
        if !self.on_table
            return false
        end

        # Assigning new coordinates depending on the orientation
        # The robot can only move 1 unit at a time
        # If the new coordinate is outside of the table, return false
        case self.orientation
        when 0
            if !(self.y + 1).between?(0,4)
                return false
            else
                self.y += 1
            end

        when 90
            if !(self.x - 1).between?(0,4)
                return false
            else
                self.x -= 1
            end

        when 180
            if !(self.y - 1).between?(0,4)
                return false
            else
                self.y -= 1
            end

        when 270
            if !(self.x + 1).between?(0,4)
                return false
            else
                self.x += 1
            end

        else
            return false # If the orientation is none of the authorised values, return false
        end

        return true
    end

    # Function to rotate the robot in the specified direction, either left or right
    def rotate(direction)
        if !self.on_table # No rotation is possible if the robot has not been placed
            return false
        end

        new_orientation = 0

        # Turning right or left means a 90 degres rotation
        # Left is a negative rotation
        # Right is a positive rotation
        case direction
        when "left"
            new_orientation = self.orientation - 90  

            # The rotation is looping in the interval [0 270] with a step of 90 
            if new_orientation < 0
                new_orientation = 270 
            end

        when "right"
            new_orientation = self.orientation + 90

            # The rotation is looping in the interval [0 270] with a step of 90 
            if new_orientation > 270
                new_orientation = 0
            end

        else
            return false # If the direction was neither right or left, return false
        end

        self.orientation = new_orientation
    end

    # Function returning the cardinal orientation (North, South, East, West) of the robot
    def get_orientation_string()
        case self.orientation
        when 0
            return "East"
        when 90
            return "South"
        when 180
            return "West"
        when 270
            return "North"
        else
            return "Invalid" # If the robot orientation is not included in [0 90 180 270] the orientation is invalid
        end
    end

    private 
        # Callback function called before saving
        # If the robot does not exists and there is already a robot in the database, the save process is aborted
        def check_uniqueness
            if !self.id && Robot.all().any?
                throw(:abort)
            end   
        end

        # Callback function called before updating
        # If the robot is not placed on the table, it cannot be updated (moved or rotated), update process is aborted
        def check_presence_on_table
            if !self.on_table
                throw(:abort)
            end
        end
end
