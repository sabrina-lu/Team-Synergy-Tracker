class User < ApplicationRecord
    attr_accessor :flag
    
    has_and_belongs_to_many :teams
    has_many :surveys
    has_and_belongs_to_many :tickets
    has_secure_password
  
    validates :first_name, presence: true, allow_blank: false
    validates :last_name, presence: true, allow_blank: false
    validates :watiam, format: {without: /\s/}, presence: true, allow_blank: false
    validates :user_id, length: {is: 8}, format: {without: /\s/}, presence: true, allow_blank: false
    validates :password, length: {in: 6..25}, on: :create, format: {without: /\s/}, allow_blank: false, presence: true

    def full_name_with_watiam
        "#{watiam}: #{first_name} #{last_name}"
    end
end
