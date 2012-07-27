class CreateSearches < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|
      t.string :search_errors
      t.string :search_results
      t.timestamps
    end
  end

  def self.down
    drop_table :searches
  end
end
