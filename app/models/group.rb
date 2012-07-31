class Group < ActiveRecord::Base
  attr_accessible :name, :search_result, :search_error
  belongs_to :search

  has_one :search_result
  has_one :search_error

  after_commit :search!

  def clear_results!
    self.search_result = nil
    self.search_error = nil
  end

  def finished?
    self.search_result.present? || self.search_error.present?
  end

  def search!
    TRIGGERED_SEARCH_DUDE
    clear_results!
    GroupWorker.perform_async(self.id)
  end

end
