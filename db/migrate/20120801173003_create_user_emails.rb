class CreateUserEmails < ActiveRecord::Migration
  def change
    create_table :user_emails do |t|
      t.string :email
      t.references :search
      t.timestamps
    end
  end
end
