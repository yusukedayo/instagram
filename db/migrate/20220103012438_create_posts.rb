class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.text :body,         null: false
      t.string :avatar,         null: false

      t.timestamps
    end
  end
end
