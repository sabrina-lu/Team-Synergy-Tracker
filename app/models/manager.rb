class Manager < ApplicationRecord
    has_and_belongs_to_many :teams
    attr_accessor :flag

    has_secure_password
    validates :first_name, presence: true, allow_blank: false
    validates :last_name, presence: true, allow_blank: false
    validates :watiam, format: {without: /[\s\W]/}, presence: true, allow_blank: false
    validates :password, length: {in: 6..25}, on: :create, format: {without: /\s/}, allow_blank: false, presence: true
end
