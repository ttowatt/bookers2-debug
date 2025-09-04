class BookCommentsController < ApplicationController
  before_action :set_book

  def create
    @comment = @book.book_comments.new(book_comment_params)
    @comment.user = current_user
    if @comment.save
      respond_to do |format|
        format.html { redirect_to @book }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to @book, alert: "コメントを入力してください" }
        format.js
      end
    end
  end

  def destroy
    @comment = @book.book_comments.find(params[:id])
    @comment.destroy if @comment.user == current_user
    respond_to do |format|
      format.html { redirect_to @book }
      format.js
    end
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end
