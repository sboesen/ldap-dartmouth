class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.text :search_errors
      t.text :search_results

      t.timestamps
    end
  end
end
