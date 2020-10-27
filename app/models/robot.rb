class Robot < ApplicationRecord
    validates :x, presence:true
    validates :y, presence:true
    validates :orientation, presence:true

    def move
        valid = true

        case self.orientation.to_i
        when 0
            if !(self.y + 1).between?(0,4)
                valid = false
            else
                self.y += 1
            end

        when 90
            if !(self.x - 1).between?(0,4)
                valid = false
            else
                self.x -= 1
            end

        when 180
            if !(self.y - 1).between?(0,4)
                valid = false
            else
                self.y -= 1
            end

        when 270
            if !(self.x + 1).between?(0,4)
                valid = false
            else
                self.x += 1
            end

        else
            valid = false
        end

        return valid
    end
end
