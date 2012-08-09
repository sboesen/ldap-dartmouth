class AddEmailMessageToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :email_message, :text
  end
end
