class Ticket < ApplicationRecord
  self.inheritance_column = nil  #override the inheritance so that type can be used as a column name
  has_and_belongs_to_many :users
  belongs_to :creator, class_name: "User"
end
