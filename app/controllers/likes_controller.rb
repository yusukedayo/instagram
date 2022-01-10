class LikesController < ApplicationController
    before_action :require_login, only: %i[create destroy]

    def create
    @post = Post.find(params[:post_id])
    # @postの中にparamsで受け取ったpost_idのpostが１つ格納される。
    current_user.like(@post)
    # userモデルで定義したlike_posts << postがcurrent_userに対して行われ、like_postsに@postが追加される。
    end


    def destroy
        @post = Like.find(params[:id]).post
        current_user.unlike(@post)
    end
end
