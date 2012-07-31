class CreateSearchErrors < ActiveRecord::Migration
  def change
    create_table :search_errors do |t|
      t.text :value
      t.references :group

      t.timestamps
    end
  end
end
