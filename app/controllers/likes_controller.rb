class LikesController < ApplicationController

  respond_to :js

  def create
    @link = Link.find(params[:link_id])
    if @link.liked_by?(current_user)
      @link.likers.delete(current_user)
      @link.touch
    else
      @link.likers << current_user
    end
    respond_with(@link.reload)
  end

end
