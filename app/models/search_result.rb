class SearchResult < ActiveRecord::Base
  attr_accessible :value, :group_id
  belongs_to :group

  def clear!
    self.value = nil
  end

  def to_s
    self.value
  end

end
