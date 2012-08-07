class GroupChildren < ActiveRecord::Base
  belongs_to :group
  attr_accessible :value, :group_id

  def clear!
    self.value = nil
  end

end
