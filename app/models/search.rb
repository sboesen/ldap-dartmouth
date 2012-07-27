class Search < ActiveRecord::Base
  attr_accessible :search_error, :search_results, :groups_attributes
  has_many :groups
  accepts_nested_attributes_for :groups, allow_destroy: true

end
