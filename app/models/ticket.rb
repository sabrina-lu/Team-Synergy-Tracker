class Ticket < ApplicationRecord
  self.inheritance_column = nil  #override the inheritance so that type can be used as a column name
  has_and_belongs_to_many :users
  belongs_to :creator, class_name: "User"
 
  validates :description, length: {in: 1..500}, presence: true, allow_blank: false
  validates_inclusion_of :priority, :in => [1, 2, 3]
  validates_inclusion_of :type, :in => ["Conflict", "Positive", "Neutral"]
  validates_inclusion_of :category, :in => ['Personal', 'Work', 'Other']
end
