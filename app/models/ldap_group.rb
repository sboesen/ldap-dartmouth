class LdapGroup < ActiveRecord::Base
  attr_accessible :name
  default_scope order: 'name ASC'
  def fetch_groups
    LdapGroupWorker.perform_async('fetch_groups')
  end
end
