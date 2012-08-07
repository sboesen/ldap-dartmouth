class AddTempColumnToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :temp, :boolean, default: false 
  end
end
