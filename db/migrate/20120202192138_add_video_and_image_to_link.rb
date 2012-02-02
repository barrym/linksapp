class AddVideoAndImageToLink < ActiveRecord::Migration
  def change
    add_column :links, :is_video, :boolean, :default => false
    add_column :links, :is_image, :boolean, :default => false
  end
end
