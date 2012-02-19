class LikesController < ApplicationController

  respond_to :js

  def create
    @link = Link.find(params[:link_id])
    if @link.liked_by?(current_user)
      @link.likers.delete(current_user)
      @link.touch # TODO: when adding caching this'll have to invalidate the cache here or something
    else
      @link.likers << current_user
    end
    respond_with(@link.reload)
  end

end
