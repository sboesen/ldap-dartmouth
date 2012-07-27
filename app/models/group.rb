class Group < ActiveRecord::Base
  attr_accessible :name
  belongs_to :search
  after_commit :run_parent_search
  def run_parent_search
    self.search.clear_results!
    self.search.run!
  end
end
