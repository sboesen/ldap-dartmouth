class CreateGroupParents < ActiveRecord::Migration
  def change
    create_table :group_parents do |t|
      t.string :value
      t.references :group

      t.timestamps
    end
    add_index :group_parents, :group_id
  end
end
