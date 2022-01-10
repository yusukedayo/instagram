class PostsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_post, only: [:edit, :update, :destroy]
  def index
    @posts = Post.all.includes(:user).page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.includes(:user).order(created_at: :desc)
    # この投稿についている全てのコメントを取得している。
    # N+1問題を避けるためにincludesメソッドが使われている。
    @comment = Comment.new
    # 投稿フォールにモデルの情報を渡すためにインスタンス変数に代入している。
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_url, success: '投稿しました'
      # _urlは何を作っているのか
    else
      flash.now[:danger] = '失敗しました'
      render :new
    end
  end

  def edit
  end

  def updated
    if @post.update(post_params)
      redirect_to posts_url, success: '投稿しました'
      # _urlは何を作っているのか
    else
      flash.now[:danger] = '失敗しました'
      render :new
    end
  end

  def destroy
    @post.destroy!
    redirect_to posts_url, success: '投稿を削除しました'
  end

  private

  def post_params
    params.require(:post).permit(:body, images: [])
  end

  def set_post
    @post = current_user.posts.find(params[:id])
  end
end
