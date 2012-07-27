class Search < ActiveRecord::Base
  attr_accessible :search_errors, :search_results, :groups_attributes
  has_many :groups
  accepts_nested_attributes_for :groups

  default_scope includes(:groups)
  def finished?
    self.search_errors.present? || self.search_results.present?
  end
  def ellipses
    (self.groups.count > 1) ? '...' : ''
  end

  def clear_results!
    self.update_attributes({search_errors: nil, search_results: nil})
  end
  def run!
    clear_results!
    SearchWorker.perform_async(self.id)
  end

end
