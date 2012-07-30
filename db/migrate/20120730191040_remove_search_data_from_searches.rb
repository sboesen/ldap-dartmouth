class RemoveSearchDataFromSearches < ActiveRecord::Migration
  def change
    remove_column :searches, :search_results
    remove_column :searches, :search_errors
  end
end
