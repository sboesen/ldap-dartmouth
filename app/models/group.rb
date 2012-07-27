class Group < ActiveRecord::Base
  attr_accessible :name
  belongs_to :search
  #validates_presence_of :search
end
