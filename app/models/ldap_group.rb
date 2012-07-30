class LdapGroup < ActiveRecord::Base
  attr_accessible :name
  def fetch_groups
    LdapGroupWorker.perform_async('fetch_groups')
  end
end
