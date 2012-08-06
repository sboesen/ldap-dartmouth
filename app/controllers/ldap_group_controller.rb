class LdapGroupController < ApplicationController
  autocomplete :ldap_group, :name
  
  def index
    @ldap_groups = LdapGroup.all
  end

end
