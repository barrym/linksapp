class AddLinksCacheToUser < ActiveRecord::Migration
  def change
      add_column :users, :links_count, :integer
  end
end
