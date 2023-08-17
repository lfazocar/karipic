class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]

  # Role permissions
  before_action :authenticate_user!, except: %i[ index show ]
  before_action only: %i[ new edit update destroy ] do
    authorize_request(["admin"])
  end

  # GET /articles or /articles.json
  def index
    @articles = Article.all.order(created_at: :desc)
  end

  # GET /articles/1 or /articles/1.json
  def show
    @comments = Comment.where(article_id: params[:id]).order(:created_at)
  end

  # POST /articles/1
  def comment
    @comment = current_user.comments.new(comment_params.merge(article_id: params[:id]))

    respond_to do |format|
      if @comment.save
        format.html { redirect_to article_path, notice: "Comment created." }
        format.json { redirect_to article_path(format: :json), status: :created, location: @article }
      else
        format.html { redirect_to article_path, flash: { error: @comment.errors.full_messages }}
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1

  def delete_comment
    @comment = Comment.find(params[:comment_id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to article_path, notice: "Comment deleted." }
      format.json { head :no_content }
    end
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = current_user.articles.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :description, :user_id, :image)
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
end
