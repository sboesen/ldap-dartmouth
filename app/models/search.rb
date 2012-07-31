class Search < ActiveRecord::Base
  attr_accessible :groups_attributes
  has_many :groups
  accepts_nested_attributes_for :groups, allow_destroy: true

  default_scope includes(:groups)
  def finished?
    self.groups.each do |group|
      return false unless group.finished?
    end
    true
  end
  def ellipses
    (self.groups.count > 1) ? '...' : ''
  end

  def groups_to_sentence
    groups.collect { |group| group.name }.to_sentence
  end

end
