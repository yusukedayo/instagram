# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  crypted_password :string(255)
#  email            :string(255)      not null
#  salt             :string(255)
#  username         :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  # オブジェクトが削除されるときに、関連付けられたオブジェクトのdestroyメソッドが実行されます。

  has_many :likes
  has_many :like_posts, through: :likes, source: :post
  # ユーザーがいいねしている投稿を取得できるメソッド。中間テーブルのlikesテーブルを経由してpostsテーブルを参照する。user_idと対になってるpost_idの投稿を取ってくる。
  
  def own?(object)
    id == object.user_id
  end

  def like(post)
    # いいねを追加するメソッド。
    # <<は指定された obj を自身の末尾に破壊的に追加している。引数のpostが新しくlike_postsに追加されている。
    like_posts << post
  end
  
  def unlike(post)
    # いいねを削除するメソッド。
    # like_postsの中から引数のpostをdestroyしている。
    like_posts.destroy(post)
  end
  
  def like?(post)
    # いいねしているかどうかを確認するメソッド。
    # like_postsの中に引数==な関係のよそがあればtrueを返す。
    like_posts.include?(post)
  end
end