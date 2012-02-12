class AddAvatarFieldsToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :image
    add_column :users, :avatar_file_name, :string
    add_column :users, :avatar_content_type, :string
    add_column :users, :avatar_file_size, :integer
    add_column :users, :avatar_uploaded_at, :datetime
  end
end
