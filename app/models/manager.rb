class Manager < ApplicationRecord
    has_and_belongs_to_many :teams
    attr_accessor :flag

    has_secure_password
    validates_presence_of :password
    validates_length_of :password, minimum: 6
end
