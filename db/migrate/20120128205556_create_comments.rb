class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|

      t.integer :link_id
      t.integer :user_id
      t.string  :body

      t.timestamps

      add_column :users, :comments_count, :integer
      add_column :links, :comments_count, :integer
    end
  end
end
