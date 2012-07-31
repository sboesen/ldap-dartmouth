class SearchError < ActiveRecord::Base
  attr_accessible :value
  belongs_to :group

  def clear!
    self.value = nil
  end

  def to_s
    self.value
  end

end
