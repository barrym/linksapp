class RenameTwitterColumnsForUser < ActiveRecord::Migration
  def change
    rename_column :users, :uid, :twitter_uid
    rename_column :users, :oauth_token, :twitter_oauth_token
    rename_column :users, :oauth_token_secret, :twitter_oauth_secret
  end
end
