class LdapGroupController < ApplicationController
  autocomplete :ldap_group, :name
  def show
  end
end
