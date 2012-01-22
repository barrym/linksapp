class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|

      t.string :url
      t.string :name
      t.string :icon
      t.integer :links_count

      t.timestamps
    end
  end
end
