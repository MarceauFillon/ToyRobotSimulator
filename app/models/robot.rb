class Robot < ApplicationRecord
    before_update :check_presence_on_table
    before_save :check_uniqueness

    validates :x, inclusion:{ :in => 0..4}
    validates :y, inclusion:{ :in => 0..4}
    validates :orientation, inclusion:{ :in => (0..270).step(90)}
    validates :on_table, inclusion:{ :in => [true, false]}

    def move
        if !self.on_table
            return false
        end

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
            new_orientation = self.orientation - 90
            if new_orientation < 0
                new_orientation = 270
            end
        when "right"
            new_orientation = self.orientation + 90
            if new_orientation > 270
                new_orientation = 0
            end
        else
            return false
        end

        self.orientation = new_orientation
    end

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
            return "Invalid"
        end
    end

    private 
        def check_uniqueness
            return !Robot.all().any?   
        end

        def check_presence_on_table
            if !self.on_table
                throw(:abort)
            end
        end
end
