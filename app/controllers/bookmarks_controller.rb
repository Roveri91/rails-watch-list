class BookmarksController < ApplicationController
  before_action :set_list
  
  def new 
    @list = List.find(params[:list_id])
    @bookmark = Bookmark.new
  end

  private

  def set_list
    @list = List.find(params[:list_id])
  end

end
