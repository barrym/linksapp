class AddLikeCacheCounts < ActiveRecord::Migration
  def up
    add_column :users, :likes_count, :integer
    add_column :links, :likes_count, :integer
  end

  def down
    remove_column :users, :likes_count
    remove_column :links, :likes_count
  end
end
