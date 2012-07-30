class AddSearchDataToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :search_results, :text
    add_column :groups, :search_errors, :text
  end
end
