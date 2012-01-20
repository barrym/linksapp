class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.integer :user_id
      t.integer :source_id
      t.string  :title
      t.string  :url
      t.string  :type
      t.timestamps
    end

    add_index(:links, :url)
  end
end
