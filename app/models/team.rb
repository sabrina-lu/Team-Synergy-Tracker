class Team < ApplicationRecord
     teams-and-managers

    belongs_to :manager
    has_and_belongs_to_many :users

    validates_presence_of :name
    validates_length_of :name, maximum: 50
end
