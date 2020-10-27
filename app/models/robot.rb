class Robot < ApplicationRecord
    validates :x, presence:true
    validates :y, presence:true
    validates :orientation, presence:true
end
