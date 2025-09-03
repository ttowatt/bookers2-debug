class BookCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    book = Book.find(params[:book_id])
    comment = book.book_comments.new(book_comment_params)
    comment.user_id = current_user.id
    if comment.save
      redirect_back(fallback_location: book_path(book)) 
    else
      redirect_back(fallback_location: book_path(book), alert: "コメントを入力してください")
    end
  end

  def destroy
    comment = BookComment.find(params[:id])
    if comment.user == current_user
      comment.destroy
    end
    redirect_back(fallback_location: book_path(comment.book))
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end
