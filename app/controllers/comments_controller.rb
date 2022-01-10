class CommentsController < ApplicationController
    before_action :require_login, only: %i[create edit update destroy]

    def create
        @comment = current_user.comments.build(comment_params)
        # Userと関連付けたインスタントを生成。buildは関連付けされていることを明示してる。
        @comment.save
        # ユーザーによるbodyカラムが空で送信されるミスが想定されるのでsave!ではなくsaveメソッドを使用。
    end

    def edit
        @comment = current_user.comments.find(params[:id])
    end

    def update
        @comment = current_user.comments.find(params[:id])
        @comment.update(comment_update_params)
        # saveと同じ理由でupdate!ではなくupdateメソッドを使用。
    end

    def destroy
        @comment = current_user.comments.find(params[:id])
        @comment.destroy!
        # destroyではユーザーによるミスは想定できないので失敗した場合には例外処理を発生させる。
    end

    private

    def comment_params
        params.require(:comment).permit(:body).merge(post_id: params[:post_id])
        # commentのbodyだけでなくpost_idも必要なのでmergeしている。
    end

    def comment_update_params
        params.require(:comment).permit(:body)
        # 編集の場合は既にpost_idも含めて保存されているのでmergeの必要はない。
    end


end
