class GroupChildren < ActiveRecord::Base
  belongs_to :group
  attr_accessible :value

  def clear!
    self.value = nil
  end

end
