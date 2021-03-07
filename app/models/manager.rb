class Manager < ApplicationRecord
    has_and_belongs_to_many :teams
    attr_accessor :flag
    # user_id added to allow for id to be passed if user is created rather than manager account
    attr_accessor :user_id

    has_secure_password
    validates :first_name, presence: true, allow_blank: false
    validates :last_name, presence: true, allow_blank: false
    validates :watiam, format: {without: /\s/}, presence: true, allow_blank: false
    validates :password, length: {in: 6..25}, on: :create, format: {without: /\s/}, allow_blank: false, presence: true
end
