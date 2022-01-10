class AddUserToPosts < ActiveRecord::Migration[5.2]
  def up
    execute 'DELETE FROM posts'
    add_reference :posts, :user, null: false, index:true, foreign_key: true
  end

  def down
    remove_reference :posts, :user, index:true
  end
end
