class AddNameToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :name, :string
  end
end
