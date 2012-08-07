class CreateGroupChildren < ActiveRecord::Migration
  def change
    create_table :group_children do |t|
      t.string :value
      t.references :group

      t.timestamps
    end
    add_index :group_children, :group_id
  end
end
