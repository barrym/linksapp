class AddShowWelcomeToUser < ActiveRecord::Migration
  def change
    add_column :users, :show_welcome, :boolean, :default => true
  end
end
