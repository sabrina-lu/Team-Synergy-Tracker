class Team < ApplicationRecord
    has_and_belongs_to_many :managers
    has_and_belongs_to_many :users
    has_many :surveys

    validates_presence_of :name
    validates_length_of :name, maximum: 50
end
