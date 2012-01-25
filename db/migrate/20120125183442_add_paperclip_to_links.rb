class AddPaperclipToLinks < ActiveRecord::Migration
  def change
    add_column :links, :image_file_name, :string
    add_column :links, :image_content_type, :string
    add_column :links, :image_file_size, :integer
    add_column :links, :image_uploaded_at, :datetime
  end
end
