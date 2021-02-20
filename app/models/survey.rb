class Survey < ApplicationRecord
  belongs_to :user
  belongs_to :team
  has_many :responses
end
