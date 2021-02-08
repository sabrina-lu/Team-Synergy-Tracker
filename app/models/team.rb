class Team < ApplicationRecord
    validates_presence_of :name
    validates_length_of :name, maximum: 70
end
