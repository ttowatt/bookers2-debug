class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book

  def create
    @book.favorites.create(user: current_user)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    favorite = @book.favorites.find_by(user: current_user)
    favorite.destroy if favorite
    redirect_back(fallback_location: root_path)
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end
end
