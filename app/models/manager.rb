class Manager < ApplicationRecord
    has_and_belongs_to_many :teams
    attr_accessor :flag
    # user_id added to allow for id to be passed if user is created rather than manager account
    attr_accessor :user_id

    has_secure_password
    validates_presence_of :password
    validates_length_of :password, minimum: 6
end
