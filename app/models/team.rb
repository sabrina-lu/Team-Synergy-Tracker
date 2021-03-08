class Team < ApplicationRecord
    has_and_belongs_to_many :managers
    has_and_belongs_to_many :users
    has_many :surveys

    validates :name, length: {in: 1..50}, presence: true, allow_blank: false
end
