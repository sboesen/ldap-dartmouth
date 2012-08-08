class Group < ActiveRecord::Base
  attr_accessible :name, :search_result, :search_error, :search, :group_children, :group_parents
  belongs_to :search


  has_one :search_result
  has_one :search_error
  has_one :group_children
  has_one :group_parents

  after_create :default_values

  after_commit :search!

  def default_values
    Rails.logger.info "=== INFO === DEFAULT VALUES CALLED. SHOULD BE RUN ON EVERY GROUP create. === INFO ==="
    self.search_result ||= SearchResult.create!(group_id: self.id)
    self.search_error ||= SearchError.create!(group_id: self.id)
    self.group_children ||= GroupChildren.create!(group_id: self.id)
    self.group_parents ||= GroupParents.create!(group_id: self.id)
  end

  def clear_results!
    self.search_result.clear! 
    self.search_error.clear! 
    self.group_parents.clear!
    self.group_children.clear!
  end

  def finished?
    self.search_result.value.present? || self.search_error.value.present? || self.group_parents.value.present? || self.group_children.value.present?
  end

  def search!
    Rails.logger.info "=== INFO === SEARCH CALLED. === INFO ==="
    clear_results!
    GroupWorker.perform_async(self.id)
  end

end
