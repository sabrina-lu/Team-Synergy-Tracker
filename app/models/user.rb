class User < ApplicationRecord
    attr_accessor :flag
    
    has_and_belongs_to_many :teams
    has_many :surveys
    has_and_belongs_to_many :tickets
    has_secure_password
    validates_presence_of :password, :first_name, :last_name, :watiam, :user_id
    validates :password, length: {in: 6..25}, on: :create
    validates :user_id, length: {is: 8}
    validates :password, format: {without: /\s/}
    validates :user_id, format: {without: /\s/}, allow_blank: false
    validates :watiam, format: {without: /\s/}, allow_blank: false
end
