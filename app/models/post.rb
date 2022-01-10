# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  images     :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
    mount_uploaders :images, PostImageUploader
    serialize :images, JSON
    
    validates :body, presence: true, length: { maximum: 1000 }

    belongs_to :user
    has_many :comments, dependent: :destroy
    # オブジェクトが削除されるときに、関連付けられたオブジェクトのdestroyメソッドが実行されます。

    has_many :likes, dependent: :destroy
    has_many :like_users, through: :likes, source: :user
    # 投稿にいいねしたユーザーを取得できるメソッド。中間テーブルのlikesテーブルを経由してusersテーブルを参照する。post_idと対になってるuser_idの投稿を取ってくる。
end
