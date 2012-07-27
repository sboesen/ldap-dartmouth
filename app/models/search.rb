class Search < ActiveRecord::Base
  attr_accessible :search_errors, :search_results, :groups_attributes
  has_many :groups
  accepts_nested_attributes_for :groups

  default_scope includes(:groups)
  def finished?
    self.search_errors.present? || self.search_results.present?
  end
end
