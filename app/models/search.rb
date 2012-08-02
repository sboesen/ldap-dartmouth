class Search < ActiveRecord::Base
  attr_accessible :groups_attributes, :groups, :name, :user_emails_attributes
  has_many :groups
  has_many :user_emails
  accepts_nested_attributes_for :groups, allow_destroy: true
  accepts_nested_attributes_for :user_emails, allow_destroy: true

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

  def run!
    groups.each do |group|
      group.search!
    end
  end

  def to_csv(options = {})
    rows = CSV.generate(options) do |row|
      groups.each do |group|
        row << [group.name, group.search_result.value.split(',')].flatten!
      end
    end
    rows
  end

end
