class CreateLdapGroups < ActiveRecord::Migration
  def change
    create_table :ldap_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
