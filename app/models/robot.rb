class Robot < ApplicationRecord
    validates :x, presence:true
    validates :y, presence:true
    validates :orientation, presence:true

    def move
        if !self.on_table
            return false
        end

        case self.orientation.to_i
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
            return false
        end

        return true
    end

    def rotate(direction)
        if !self.on_table
            return false
        end

        new_orientation = 0

        case direction
        when "left"
            new_orientation = self.orientation.to_i - 90
            if new_orientation < 0
                new_orientation = 270
            end
        when "right"
            new_orientation = self.orientation.to_i + 90
            if new_orientation > 270
                new_orientation = 0
            end
        else
            return false
        end

        self.orientation = new_orientation
    end

    def get_orientation_string()
        case self.orientation.to_i
        when 0
            return "East"
        when 90
            return "South"
        when 180
            return "West"
        when 270
            return "North"
        else
            return "Orientation invalid"
        end
    end
end
