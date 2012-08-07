class Group < ActiveRecord::Base
  attr_accessible :name, :search_result, :search_error, :search
  belongs_to :search


  has_one :search_result
  has_one :search_error

  after_create :default_values

  after_commit :search!

  def default_values
    Rails.logger.info "=== INFO === DEFAULT VALUES CALLED. SHOULD BE RUN ON EVERY GROUP create. === INFO ==="
    self.search_result ||= SearchResult.create!(group_id: self.id)
    self.search_error ||= SearchError.create!(group_id: self.id)
  end

  def clear_results!
    self.search_result.clear! 
    self.search_error.clear! 
  end

  def finished?
    self.search_result.value.present? || self.search_error.value.present?
  end

  def search!
    Rails.logger.info "=== INFO === SEARCH CALLED. === INFO ==="
    clear_results!
    GroupWorker.perform_async(self.id)
  end

end
