class CreateSearchResults < ActiveRecord::Migration
  def change
    create_table :search_results do |t|
      t.text :value
      t.references :group

      t.timestamps
    end
  end
end
