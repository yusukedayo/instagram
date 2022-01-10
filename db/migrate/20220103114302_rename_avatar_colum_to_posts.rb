class RenameAvatarColumToPosts < ActiveRecord::Migration[5.2]
  def change
    rename_column :posts, :avatar, :images
  end
end
