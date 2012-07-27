class Group < ActiveRecord::Base
  attr_accessible :name
  belongs_to :search
end
