class SearchesController < ApplicationController
  before_action :authenticate_user!  

  def search
    @keyword = params[:keyword]
    @model = params[:model]
    match_type = params[:match_type]
  
    if @model == "user"
      if match_type == "exact"
        @results = User.where(name: @keyword)
      else
        @results = User.where("name LIKE ?", "%#{@keyword}%")
      end
    elsif @model == "book"
      if match_type == "exact"
        @results = Book.where(title: @keyword)
      else
        @results = Book.where("title LIKE ?", "%#{@keyword}%")
      end
    else
      @results = []
    end
  end
  
end
